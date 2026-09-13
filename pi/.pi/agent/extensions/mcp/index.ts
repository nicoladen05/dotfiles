import {
	DEFAULT_MAX_BYTES,
	DEFAULT_MAX_LINES,
	formatSize,
	truncateHead,
	type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import { Client, StreamableHTTPClientTransport, type Tool } from "@modelcontextprotocol/client";
import { StdioClientTransport } from "@modelcontextprotocol/client/stdio";
import { mkdtemp, readFile, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { Type } from "typebox";

interface ServerConfig {
	url?: string;
	command?: string;
	args?: string[];
	env?: Record<string, string>;
	cwd?: string;
}

interface Config {
	servers: Record<string, ServerConfig>;
}

type PiContent =
	| { type: "text"; text: string }
	| { type: "image"; data: string; mimeType: string };

const configPath = join(dirname(fileURLToPath(import.meta.url)), "mcp.json");

function toolName(server: string, remote: string): string {
	return `mcp_${server}_${remote}`.toLowerCase().replace(/[^a-z0-9_-]+/g, "_");
}

function validateConfig(value: unknown): Config {
	if (!value || typeof value !== "object" || !("servers" in value) || !value.servers || typeof value.servers !== "object") {
		throw new Error(`${configPath}: expected { "servers": { ... } }`);
	}

	for (const [name, raw] of Object.entries(value.servers)) {
		if (!/^[a-z0-9_-]+$/i.test(name) || !raw || typeof raw !== "object") {
			throw new Error(`${configPath}: invalid server ${name}`);
		}
		const server = raw as ServerConfig;
		if ((typeof server.url === "string") === (typeof server.command === "string")) {
			throw new Error(`${configPath}: ${name} must define exactly one of url or command`);
		}
		if (server.url && !/^https?:$/.test(new URL(server.url).protocol)) {
			throw new Error(`${configPath}: ${name} URL must use http or https`);
		}
		if (server.args && (!Array.isArray(server.args) || server.args.some((arg) => typeof arg !== "string"))) {
			throw new Error(`${configPath}: ${name}.args must be strings`);
		}
		if (server.env && Object.values(server.env).some((entry) => typeof entry !== "string")) {
			throw new Error(`${configPath}: ${name}.env values must be strings`);
		}
	}

	return value as Config;
}

async function truncateText(text: string): Promise<string> {
	const truncated = truncateHead(text, { maxBytes: DEFAULT_MAX_BYTES, maxLines: DEFAULT_MAX_LINES });
	if (!truncated.truncated) return text;

	const dir = await mkdtemp(join(tmpdir(), "pi-mcp-"));
	const path = join(dir, "result.txt");
	await writeFile(path, text, { encoding: "utf8", mode: 0o600 });
	return `${truncated.content}\n\n[Output truncated: ${truncated.outputLines} of ${truncated.totalLines} lines (${formatSize(truncated.outputBytes)} of ${formatSize(truncated.totalBytes)}). Full output saved to: ${path}]`;
}

async function resultContent(result: Awaited<ReturnType<Client["callTool"]>>): Promise<PiContent[]> {
	const text: string[] = [];
	const images: PiContent[] = [];

	for (const block of result.content) {
		if (block.type === "text") text.push(block.text);
		else if (block.type === "image") images.push({ type: "image", data: block.data, mimeType: block.mimeType });
		else if (block.type === "audio") text.push(`[MCP audio omitted: ${block.mimeType}]`);
		else text.push(JSON.stringify(block));
	}

	const content: PiContent[] = [];
	if (text.length) content.push({ type: "text", text: await truncateText(text.join("\n")) });
	content.push(...images);
	return content.length ? content : [{ type: "text", text: "MCP tool returned no content." }];
}

export default async function mcpOnDemand(pi: ExtensionAPI) {
	const config = validateConfig(JSON.parse(await readFile(configPath, "utf8")));
	const clients = new Map<string, Client>();
	const activeMcpTools = new Set<string>();
	const registeredTools = new Set<string>();

	async function closeAll() {
		activeMcpTools.clear();
		pi.setActiveTools(pi.getActiveTools().filter((name) => !registeredTools.has(name)));
		const open = [...clients.values()];
		clients.clear();
		await Promise.allSettled(open.map((client) => client.close()));
	}

	async function activate(serverName: string): Promise<string[]> {
		const existing = clients.get(serverName);
		if (existing) return [...activeMcpTools].filter((name) => name.startsWith(`mcp_${serverName}_`));

		const server = config.servers[serverName];
		if (!server) throw new Error(`Unknown MCP server "${serverName}". Configured: ${Object.keys(config.servers).join(", ") || "none"}`);

		const client = new Client({ name: "pi-mcp-on-demand", version: "0.1.0" });
		const transport = server.url
			? new StreamableHTTPClientTransport(new URL(server.url))
			: new StdioClientTransport({
					command: server.command!,
					args: server.args,
					env: server.env,
					cwd: server.cwd,
				});

		let names: string[] = [];
		try {
			await client.connect(transport);
			const { tools } = await client.listTools();
			if (!tools.length) throw new Error(`MCP server "${serverName}" exposes no tools`);
			names = tools.map((tool) => toolName(serverName, tool.name));
			if (new Set(names).size !== names.length) throw new Error(`MCP server "${serverName}" has colliding tool names after normalization`);

			const configuredNames = new Set(pi.getAllTools().map((tool) => tool.name));
			for (const name of names) {
				if (configuredNames.has(name) && !registeredTools.has(name)) throw new Error(`MCP tool name conflicts with existing Pi tool: ${name}`);
			}

			clients.set(serverName, client);
			tools.forEach((tool, index) => register(tool, names[index]!, serverName));
			names.forEach((name) => activeMcpTools.add(name));
			pi.setActiveTools([...new Set([...pi.getActiveTools(), ...names])]);
			return names;
		} catch (error) {
			clients.delete(serverName);
			pi.setActiveTools(pi.getActiveTools().filter((name) => !names.includes(name)));
			await client.close().catch(() => {});
			throw error;
		}
	}

	function register(tool: Tool, name: string, serverName: string) {
		if (registeredTools.has(name)) return;
		registeredTools.add(name);
		pi.registerTool({
			name,
			label: `MCP ${serverName}: ${tool.title ?? tool.name}`,
			description: `${tool.description ?? tool.title ?? tool.name} (MCP server: ${serverName})`,
			parameters: Type.Unsafe<Record<string, unknown>>(tool.inputSchema),
			async execute(_toolCallId, params, signal) {
				const client = clients.get(serverName);
				if (!client) throw new Error(`MCP server "${serverName}" is not active; invoke /mcp:${serverName} again`);
				const result = await client.callTool({ name: tool.name, arguments: params }, { signal, toolDefinition: tool });
				const content = await resultContent(result);
				if (result.isError) throw new Error(content.filter((block) => block.type === "text").map((block) => block.text).join("\n") || "MCP tool failed");
				return { content, details: { server: serverName, tool: tool.name, structuredContent: result.structuredContent } };
			},
		});
	}

	pi.on("input", async (event, ctx) => {
		const match = event.text.match(/^\/mcp:([a-z0-9_-]+)(?:\s+([\s\S]*))?$/i);
		if (!match) return { action: "continue" };

		const serverName = match[1]!.toLowerCase();
		const prompt = match[2]?.trim();
		if (!prompt) {
			ctx.ui.notify(`Usage: /mcp:${serverName} <prompt>`, "warning");
			return { action: "handled" };
		}

		try {
			const names = await activate(serverName);
			ctx.ui.notify(`Loaded ${names.length} tool${names.length === 1 ? "" : "s"} from ${serverName}`, "info");
			return { action: "transform", text: prompt, images: event.images };
		} catch (error) {
			ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
			return { action: "handled" };
		}
	});

	pi.on("agent_settled", closeAll);
	pi.on("session_shutdown", closeAll);
}
