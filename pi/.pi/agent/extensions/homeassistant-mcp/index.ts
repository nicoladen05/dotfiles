import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StreamableHTTPClientTransport } from "@modelcontextprotocol/sdk/client/streamableHttp.js";

const MCP_URL = "http://192.168.2.180:9583/private_YgBWfVWM2SvX3sMUXPDiDQ";
const TOOL_PREFIX = "";

type McpTool = {
	name: string;
	description?: string;
	inputSchema?: Record<string, unknown>;
	annotations?: { title?: string };
};

let client: Client | null = null;
let connected = false;
const registeredNames = new Map<string, string>();

function safeToolName(name: string): string {
	const sanitized = name.replace(/[^A-Za-z0-9_]/g, "_").replace(/^([^A-Za-z_])/, "_$1");
	return `${TOOL_PREFIX}${sanitized}`;
}

function asObjectSchema(schema: unknown): Record<string, unknown> {
	if (schema && typeof schema === "object" && (schema as { type?: unknown }).type === "object") {
		return schema as Record<string, unknown>;
	}

	return {
		type: "object",
		properties: {},
		additionalProperties: true,
	};
}

function resultToText(result: unknown): string {
	if (!result || typeof result !== "object") return String(result ?? "");

	const content = (result as { content?: unknown }).content;
	if (Array.isArray(content)) {
		const parts = content.map((part) => {
			if (!part || typeof part !== "object") return String(part);
			const typed = part as Record<string, unknown>;
			if (typed.type === "text") return String(typed.text ?? "");
			return JSON.stringify(typed);
		});
		return parts.join("\n");
	}

	return JSON.stringify(result, null, 2);
}

async function getClient(): Promise<Client> {
	if (client && connected) return client;

	client = new Client({ name: "pi-homeassistant-mcp", version: "1.0.0" });
	const transport = new StreamableHTTPClientTransport(new URL(MCP_URL));
	await client.connect(transport);
	connected = true;
	return client;
}

async function refreshTools(pi: ExtensionAPI): Promise<number> {
	const mcp = await getClient();
	const { tools } = await mcp.listTools();

	for (const tool of tools as McpTool[]) {
		let toolName = safeToolName(tool.name);
		let suffix = 2;
		while (registeredNames.has(toolName) && registeredNames.get(toolName) !== tool.name) {
			toolName = `${safeToolName(tool.name)}_${suffix++}`;
		}
		registeredNames.set(toolName, tool.name);

		const originalName = tool.name;
		pi.registerTool({
			name: toolName,
			label: tool.annotations?.title ?? `Home Assistant: ${originalName}`,
			description: tool.description ?? `Call Home Assistant MCP tool ${originalName}`,
			promptSnippet: tool.description ?? `Call Home Assistant MCP tool ${originalName}`,
			promptGuidelines: [
				`Use ${toolName} for Home Assistant operations provided by the remote Home Assistant MCP server.`,
			],
			parameters: asObjectSchema(tool.inputSchema) as any,
			async execute(_toolCallId, params, signal, onUpdate) {
				onUpdate?.({ content: [{ type: "text", text: `Calling Home Assistant MCP tool ${originalName}...` }] });
				const activeClient = await getClient();
				const result = await activeClient.callTool(
					{ name: originalName, arguments: params as Record<string, unknown> },
					undefined,
					{ signal } as any,
				);

				return {
					content: [{ type: "text", text: resultToText(result) }],
					details: { mcpTool: originalName, result },
				};
			},
		});
	}

	return tools.length;
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		try {
			const count = await refreshTools(pi);
			ctx.ui.notify(`Home Assistant MCP connected (${count} tools).`, "info");
		} catch (error) {
			connected = false;
			ctx.ui.notify(`Home Assistant MCP connection failed: ${error instanceof Error ? error.message : String(error)}`, "error");
		}
	});

	pi.on("session_shutdown", async () => {
		connected = false;
		await client?.close().catch(() => undefined);
		client = null;
	});

	pi.registerCommand("ha_mcp_reload", {
		description: "Reconnect to Home Assistant MCP and refresh Home Assistant tools",
		handler: async (_args, ctx) => {
			try {
				connected = false;
				await client?.close().catch(() => undefined);
				client = null;
				const count = await refreshTools(pi);
				ctx.ui.notify(`Home Assistant MCP refreshed (${count} tools).`, "info");
			} catch (error) {
				connected = false;
				ctx.ui.notify(`Home Assistant MCP refresh failed: ${error instanceof Error ? error.message : String(error)}`, "error");
			}
		},
	});
}
