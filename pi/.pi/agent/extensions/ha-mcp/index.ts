import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import { StreamableHTTPClientTransport } from "@modelcontextprotocol/sdk/client/streamableHttp.js";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

const EXT_DIR = "/home/nico/.pi/agent/extensions/ha-mcp";
const ENV_FILE = join(EXT_DIR, "ha-mcp.env");
const DEFAULT_IMAGE = "ghcr.io/homeassistant-ai/ha-mcp:latest";

type JsonObject = Record<string, unknown>;
type ProxyKind = "auto" | "read" | "write" | "delete";

function loadEnvFile(path: string): Record<string, string> {
  if (!existsSync(path)) return {};
  const env: Record<string, string> = {};
  for (const rawLine of readFileSync(path, "utf8").split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;
    const match = line.match(/^([A-Za-z_][A-Za-z0-9_]*)=(.*)$/);
    if (!match) continue;
    let value = match[2].trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    env[match[1]] = value;
  }
  return env;
}

function contentToText(result: unknown): string {
  const anyResult = result as { content?: Array<any>; structuredContent?: unknown; isError?: boolean };
  const parts: string[] = [];
  if (Array.isArray(anyResult.content)) {
    for (const item of anyResult.content) {
      if (item?.type === "text" && typeof item.text === "string") parts.push(item.text);
      else parts.push(JSON.stringify(item));
    }
  }
  if (anyResult.structuredContent !== undefined) {
    parts.push(JSON.stringify(anyResult.structuredContent, null, 2));
  }
  if (parts.length === 0) return JSON.stringify(result, null, 2);
  return parts.join("\n");
}

function categoryProxy(kind: Exclude<ProxyKind, "auto">): string {
  return kind === "read" ? "ha_call_read_tool" : kind === "write" ? "ha_call_write_tool" : "ha_call_delete_tool";
}

function guessKind(name: string): Exclude<ProxyKind, "auto"> {
  if (/_remove_|_delete_/.test(name)) return "delete";
  if (/^(ha_get_|ha_list_|ha_search|ha_eval_|ha_config_get_|ha_config_list_|ha_report_issue)/.test(name)) return "read";
  return "write";
}

export default function (pi: ExtensionAPI) {
  let client: Client | undefined;
  let connecting: Promise<Client> | undefined;
  let exposedTools: string[] = [];

  async function getClient(): Promise<Client> {
    if (client) return client;
    if (connecting) return connecting;

    connecting = (async () => {
      const fileEnv = loadEnvFile(ENV_FILE);
      const mergedEnv = {
        ...process.env,
        ...fileEnv,
        ENABLE_TOOL_SEARCH: fileEnv.ENABLE_TOOL_SEARCH ?? process.env.ENABLE_TOOL_SEARCH ?? "true",
        TOOL_SEARCH_MAX_RESULTS: fileEnv.TOOL_SEARCH_MAX_RESULTS ?? process.env.TOOL_SEARCH_MAX_RESULTS ?? "5",
      } as Record<string, string>;

      const c = new Client({ name: "pi-ha-mcp", version: "1.0.0" });
      const remoteUrl = mergedEnv.HA_MCP_URL || mergedEnv.HAMCP_URL;
      if (!remoteUrl) {
        if (!mergedEnv.HOMEASSISTANT_URL || mergedEnv.HOMEASSISTANT_URL.includes("your-homeassistant")) {
          throw new Error(`Set HOMEASSISTANT_URL in ${ENV_FILE} (or set HA_MCP_URL for an existing ha-mcp endpoint).`);
        }
        if (!mergedEnv.HOMEASSISTANT_TOKEN || mergedEnv.HOMEASSISTANT_TOKEN.includes("replace_with") || mergedEnv.HOMEASSISTANT_TOKEN.includes("your_long_lived")) {
          throw new Error(`Set HOMEASSISTANT_TOKEN in ${ENV_FILE} (Home Assistant Profile -> Long-Lived Access Tokens).`);
        }
      }
      if (remoteUrl) {
        const headers: Record<string, string> = {};
        if (mergedEnv.HA_MCP_AUTHORIZATION) headers.Authorization = mergedEnv.HA_MCP_AUTHORIZATION;
        else if (mergedEnv.HA_MCP_TOKEN) headers.Authorization = `Bearer ${mergedEnv.HA_MCP_TOKEN}`;
        await c.connect(new StreamableHTTPClientTransport(new URL(remoteUrl), { requestInit: { headers } }));
      } else {
        const uvx = "/home/nico/.local/bin/uvx";
        const useUvx = !mergedEnv.HA_MCP_COMMAND && existsSync(uvx);
        const command = mergedEnv.HA_MCP_COMMAND || (useUvx ? uvx : "docker");
        const args = mergedEnv.HA_MCP_COMMAND
          ? (mergedEnv.HA_MCP_ARGS ? JSON.parse(mergedEnv.HA_MCP_ARGS) : [])
          : useUvx
            ? ["--python", "3.13", "ha-mcp"]
            : [
                "run", "--rm", "-i",
                "-e", "HOMEASSISTANT_URL",
                "-e", "HOMEASSISTANT_TOKEN",
                "-e", "HA_VERIFY_SSL",
                "-e", "ENABLE_TOOL_SEARCH",
                "-e", "TOOL_SEARCH_MAX_RESULTS",
                "-e", "PINNED_TOOLS",
                "-e", "DISABLED_TOOLS",
                "-e", "ENABLE_WEBSOCKET",
                mergedEnv.HA_MCP_DOCKER_IMAGE || DEFAULT_IMAGE,
              ];
        await c.connect(new StdioClientTransport({ command, args, env: mergedEnv }));
      }

      const list = await c.listTools();
      exposedTools = (list.tools ?? []).map((tool) => tool.name);
      client = c;
      return c;
    })();

    try {
      return await connecting;
    } finally {
      connecting = undefined;
    }
  }

  async function callMcpTool(name: string, args: JsonObject): Promise<unknown> {
    const c = await getClient();
    return c.callTool({ name, arguments: args });
  }

  pi.on("session_shutdown", async () => {
    const c = client;
    client = undefined;
    connecting = undefined;
    exposedTools = [];
    if (c) await c.close().catch(() => undefined);
  });

  pi.registerTool({
    name: "ha_mcp_status",
    label: "HA MCP Status",
    description: "Connect to the Home Assistant MCP server and show the small exposed tool surface. Does not load the full HA tool catalog into Pi context.",
    promptSnippet: "Check Home Assistant MCP connection status and exposed proxy tools.",
    parameters: Type.Object({}),
    async execute() {
      await getClient();
      return { content: [{ type: "text", text: `Connected to ha-mcp. Exposed MCP tools: ${exposedTools.join(", ")}` }] };
    },
  });

  pi.registerTool({
    name: "ha_mcp_search_tools",
    label: "HA MCP Search Tools",
    description: "Search Home Assistant MCP tools on demand. Use this before calling Home Assistant tools. This keeps Pi from loading all ha-mcp tools initially.",
    promptSnippet: "Search Home Assistant MCP tools lazily before using ha_mcp_call_tool.",
    promptGuidelines: ["Use ha_mcp_search_tools before ha_mcp_call_tool unless you already know the exact ha-mcp tool name and category."],
    parameters: Type.Object({
      query: Type.String({ description: "Keywords describing the Home Assistant task, e.g. 'turn on light', 'automation traces', 'create dashboard card'." }),
    }),
    async execute(_toolCallId, params) {
      const result = await callMcpTool("ha_search_tools", { query: params.query });
      return { content: [{ type: "text", text: contentToText(result) }], details: result as any };
    },
  });

  pi.registerTool({
    name: "ha_mcp_call_tool",
    label: "HA MCP Call Tool",
    description: "Call a Home Assistant MCP tool found with ha_mcp_search_tools. Uses ha-mcp's read/write/delete proxy tools so the full catalog stays out of Pi context.",
    promptSnippet: "Call one discovered Home Assistant MCP tool by name via the lazy proxy.",
    promptGuidelines: [
      "Use ha_mcp_call_tool only after selecting a tool from ha_mcp_search_tools or when the exact ha-mcp tool name is known.",
      "For ha_mcp_call_tool kind, use the category returned by ha_mcp_search_tools when available; otherwise choose read for get/list/search/config_get operations, delete for remove/delete operations, and write for create/update/control operations.",
    ],
    parameters: Type.Object({
      name: Type.String({ description: "Underlying ha-mcp tool name, e.g. ha_search, ha_get_state, ha_call_service." }),
      kind: Type.Optional(Type.Union([
        Type.Literal("auto"),
        Type.Literal("read"),
        Type.Literal("write"),
        Type.Literal("delete"),
      ], { description: "Tool category/proxy to use. Prefer the category from ha_mcp_search_tools. Default auto guesses from the name." })),
      arguments: Type.Optional(Type.Record(Type.String(), Type.Any(), { description: "Arguments for the underlying ha-mcp tool." })),
    }),
    async execute(_toolCallId, params) {
      const kind = ((params.kind as ProxyKind | undefined) ?? "auto") === "auto" ? guessKind(params.name) : params.kind as Exclude<ProxyKind, "auto">;
      const result = await callMcpTool(categoryProxy(kind), { name: params.name, arguments: params.arguments ?? {} });
      return { content: [{ type: "text", text: contentToText(result) }], details: result as any };
    },
  });

  pi.registerCommand("ha-mcp-reconnect", {
    description: "Reconnect the Home Assistant MCP bridge",
    handler: async (_args, ctx) => {
      const c = client;
      client = undefined;
      connecting = undefined;
      exposedTools = [];
      if (c) await c.close().catch(() => undefined);
      await getClient();
      ctx.ui.notify(`ha-mcp reconnected (${exposedTools.length} exposed tools)`, "info");
    },
  });
}
