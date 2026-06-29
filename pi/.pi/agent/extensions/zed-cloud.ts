import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import type { AssistantMessage, Context, Model, SimpleStreamOptions } from "@earendil-works/pi-ai";
import { createAssistantMessageEventStream } from "@earendil-works/pi-ai";
import { dirname, join } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { execFileSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";

const piAiDist = dirname(fileURLToPath(import.meta.resolve("@earendil-works/pi-ai")));
const { convertResponsesTools, processResponsesStream } = await import(
  pathToFileURL(join(piAiDist, "api/openai-responses-shared.js")).href
);

const SERVER_URL = process.env.ZED_SERVER_URL || "https://zed.dev";
const CLOUD_URL = SERVER_URL === "http://localhost:3000" ? "http://localhost:8787" : "https://cloud.zed.dev";
const LLM_URL = SERVER_URL === "https://staging.zed.dev" ? "https://llm-staging.zed.dev" : CLOUD_URL;
const PROVIDER = "zed-cloud";

let cachedAuth: Promise<Auth> | undefined;
let cachedLlmToken: Promise<string> | undefined;

type Auth = { userId: string; accessToken: string; organizationId: string; systemId?: string };
type ZedModel = {
  provider: "open_ai" | "anthropic" | "google" | "x_ai";
  id: string;
  display_name: string;
  max_token_count: number;
  max_output_tokens: number;
  supports_tools: boolean;
  supports_images: boolean;
  supports_thinking: boolean;
  supports_disabling_thinking?: boolean;
  supported_effort_levels?: Array<{ value: string }>;
  is_disabled?: boolean;
};

export default async function (pi: ExtensionAPI) {
  const auth = await getAuth();
  const models = (await zedFetch<{ models: ZedModel[] }>("/models", { llm: true, auth })).models
    .filter((model) => (model.provider === "open_ai" || model.provider === "anthropic") && !model.is_disabled)
    .map(toPiModel);

  pi.registerProvider(PROVIDER, {
    name: "Zed Cloud",
    baseUrl: LLM_URL,
    api: "zed-cloud-openai" as any,
    apiKey: "zed-cloud",
    models,
    streamSimple: streamZed as any,
  });

  pi.registerCommand("zed-cloud-status", {
    description: "Check Zed Cloud auth/model availability",
    handler: async (_args, ctx) => {
      ctx.ui.notify(`Zed Cloud: ${models.length} model(s) from org ${auth.organizationId}`, "info");
    },
  });
}

function toPiModel(model: ZedModel) {
  const levels = new Set((model.supported_effort_levels ?? []).map((level) => level.value));
  return {
    id: model.id,
    name: `Zed ${model.display_name}`,
    api: "zed-cloud-openai" as any,
    reasoning: model.supports_thinking,
    thinkingLevelMap: model.supports_thinking
      ? {
          off: model.supports_disabling_thinking ? "none" : null,
          minimal: levels.has("minimal") ? "minimal" : undefined,
          low: levels.has("low") ? "low" : undefined,
          medium: levels.has("medium") ? "medium" : undefined,
          high: levels.has("high") ? "high" : undefined,
          xhigh: levels.has("xhigh") ? "xhigh" : undefined,
        }
      : undefined,
    input: model.supports_images ? ["text", "image"] : ["text"],
    contextWindow: model.max_token_count || 128000,
    maxTokens: model.max_output_tokens || 16384,
    cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
  };
}

function convertZedInput(context: Context) {
  const input: any[] = [];
  for (const message of context.messages) {
    if (message.role === "user") {
      input.push({ type: "message", role: "user", content: toInputContent(message.content) });
    } else if (message.role === "assistant") {
      const content = message.content.flatMap((block) => block.type === "text" ? [{ type: "output_text", text: block.text, annotations: [] }] : []);
      if (content.length) input.push({ type: "message", role: "assistant", content });
      for (const block of message.content) {
        if (block.type === "toolCall") input.push({ type: "function_call", call_id: block.id, name: block.name, arguments: JSON.stringify(block.arguments ?? {}) });
        if (block.type === "thinking" && block.thinkingSignature) input.push({ type: "reasoning", encrypted_content: block.thinkingSignature });
      }
    } else if (message.role === "toolResult") {
      input.push({ type: "function_call_output", call_id: message.toolCallId, output: toText(message.content) });
    }
  }
  return input;
}

function toInputContent(content: any) {
  if (typeof content === "string") return [{ type: "input_text", text: content }];
  return content.map((block: any) => block.type === "image" ? { type: "input_image", image_url: `data:${block.mimeType};base64,${block.data}` } : { type: "input_text", text: block.text ?? "" });
}

function toText(content: any[]) {
  return content.map((block) => block.type === "text" ? block.text : `[${block.mimeType} image]`).join("\n");
}
function streamZed(model: Model<any>, context: Context, options?: SimpleStreamOptions) {
  return model.id.startsWith("claude-")
    ? streamZedAnthropic(model, context, options)
    : streamZedOpenAI(model, context, options);
}

function streamZedOpenAI(model: Model<any>, context: Context, options?: SimpleStreamOptions) {
  const stream = createAssistantMessageEventStream();
  const output: AssistantMessage = {
    role: "assistant",
    content: [],
    api: model.api,
    provider: model.provider,
    model: model.id,
    usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, totalTokens: 0, cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0 } },
    stopReason: "stop",
    timestamp: Date.now(),
  };

  (async () => {
    try {
      const effort = options?.reasoning ? model.thinkingLevelMap?.[options.reasoning] ?? options.reasoning : undefined;
      let providerRequest: any = {
        model: model.id,
        instructions: context.systemPrompt,
        input: convertZedInput(context),
        stream: true,
        store: false,
      };
      if (options?.maxTokens) providerRequest.max_output_tokens = options.maxTokens;
      if (options?.temperature !== undefined) providerRequest.temperature = options.temperature;
      if (context.tools?.length) providerRequest.tools = convertResponsesTools(context.tools);
      if (model.reasoning && effort && effort !== "off") {
        providerRequest.reasoning = { effort, summary: "auto" };
        providerRequest.include = ["reasoning.encrypted_content"];
      }

      const replacement = await options?.onPayload?.(providerRequest, model);
      if (replacement !== undefined) providerRequest = replacement;

      const auth = await getAuth();
      const response = await zedFetchResponse("/completions", {
        llm: true,
        auth,
        signal: options?.signal,
        method: "POST",
        body: JSON.stringify({ provider: "open_ai", model: model.id, provider_request: providerRequest }),
        headers: {
          "content-type": "application/json",
          "x-zed-client-supports-status-messages": "true",
          "x-zed-client-supports-stream-ended-request-completion-status": "true",
          ...zedVersionHeader(),
        },
      });

      await options?.onResponse?.({ status: response.status, headers: Object.fromEntries(response.headers.entries()) }, model);
      stream.push({ type: "start", partial: output });
      await processResponsesStream(zedEvents(response), output, stream, model);
      if (options?.signal?.aborted) throw new Error("Request was aborted");
      stream.push({ type: "done", reason: output.stopReason, message: output });
      stream.end();
    } catch (error) {
      output.stopReason = options?.signal?.aborted ? "aborted" : "error";
      output.errorMessage = error instanceof Error ? error.message : String(error);
      stream.push({ type: "error", reason: output.stopReason, error: output });
      stream.end();
    }
  })();

  return stream;
}

function streamZedAnthropic(model: Model<any>, context: Context, options?: SimpleStreamOptions) {
  const stream = createAssistantMessageEventStream();
  const output: AssistantMessage = {
    role: "assistant",
    content: [],
    api: model.api,
    provider: model.provider,
    model: model.id,
    usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, totalTokens: 0, cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0 } },
    stopReason: "stop",
    timestamp: Date.now(),
  };

  (async () => {
    try {
      const effort = options?.reasoning ? model.thinkingLevelMap?.[options.reasoning] ?? options.reasoning : undefined;
      let providerRequest: any = {
        model: model.id,
        system: context.systemPrompt ? [{ type: "text", text: context.systemPrompt }] : undefined,
        messages: convertAnthropicMessages(context),
        max_tokens: options?.maxTokens ?? model.maxTokens,
        stream: true,
      };
      if (options?.temperature !== undefined && !effort) providerRequest.temperature = options.temperature;
      if (context.tools?.length) providerRequest.tools = context.tools.map((tool) => ({ name: tool.name, description: tool.description, input_schema: tool.parameters }));
      if (model.reasoning && effort && effort !== "off") {
        providerRequest.thinking = { type: "enabled", budget_tokens: Math.min(4096, (providerRequest.max_tokens ?? 8192) - 1), display: "summarized" };
      } else if (model.reasoning && model.thinkingLevelMap?.off !== null) {
        providerRequest.thinking = { type: "disabled" };
      }

      const replacement = await options?.onPayload?.(providerRequest, model);
      if (replacement !== undefined) providerRequest = replacement;

      const auth = await getAuth();
      const response = await zedFetchResponse("/completions", {
        llm: true,
        auth,
        signal: options?.signal,
        method: "POST",
        body: JSON.stringify({ provider: "anthropic", model: model.id, provider_request: providerRequest }),
        headers: {
          "content-type": "application/json",
          "x-zed-client-supports-status-messages": "true",
          "x-zed-client-supports-stream-ended-request-completion-status": "true",
          ...zedVersionHeader(),
        },
      });

      await options?.onResponse?.({ status: response.status, headers: Object.fromEntries(response.headers.entries()) }, model);
      stream.push({ type: "start", partial: output });
      await processAnthropicEvents(zedEvents(response), output, stream);
      if (options?.signal?.aborted) throw new Error("Request was aborted");
      stream.push({ type: "done", reason: output.stopReason, message: output });
      stream.end();
    } catch (error) {
      output.stopReason = options?.signal?.aborted ? "aborted" : "error";
      output.errorMessage = error instanceof Error ? error.message : String(error);
      stream.push({ type: "error", reason: output.stopReason, error: output });
      stream.end();
    }
  })();

  return stream;
}

function convertAnthropicMessages(context: Context) {
  const messages: any[] = [];
  for (const message of context.messages) {
    if (message.role === "user") {
      const content = toAnthropicContent(message.content);
      if (content.length) messages.push({ role: "user", content });
    } else if (message.role === "assistant") {
      const content: any[] = [];
      for (const block of message.content) {
        if (block.type === "text" && block.text.trim()) content.push({ type: "text", text: block.text });
        if (block.type === "thinking" && block.thinkingSignature) content.push({ type: "thinking", thinking: block.thinking, signature: block.thinkingSignature });
        if (block.type === "toolCall") content.push({ type: "tool_use", id: block.id, name: block.name, input: block.arguments ?? {} });
      }
      if (content.length) messages.push({ role: "assistant", content });
    } else if (message.role === "toolResult") {
      messages.push({ role: "user", content: [{ type: "tool_result", tool_use_id: message.toolCallId, content: toAnthropicContent(message.content), is_error: message.isError }] });
    }
  }
  return messages;
}

function toAnthropicContent(content: any) {
  if (typeof content === "string") return content.trim() ? [{ type: "text", text: content }] : [];
  return content.map((block: any) => block.type === "image"
    ? { type: "image", source: { type: "base64", media_type: block.mimeType, data: block.data } }
    : { type: "text", text: block.text ?? "" }).filter((block: any) => block.type !== "text" || block.text.trim());
}

async function processAnthropicEvents(events: AsyncIterable<any>, output: AssistantMessage, stream: any) {
  const blocks = output.content as any[];
  for await (const event of events) {
    if (event.type === "message_start") {
      output.responseId = event.message?.id;
      const usage = event.message?.usage ?? {};
      output.usage.input = usage.input_tokens ?? 0;
      output.usage.output = usage.output_tokens ?? 0;
      output.usage.cacheRead = usage.cache_read_input_tokens ?? 0;
      output.usage.cacheWrite = usage.cache_creation_input_tokens ?? 0;
      output.usage.totalTokens = output.usage.input + output.usage.output + output.usage.cacheRead + output.usage.cacheWrite;
    } else if (event.type === "content_block_start") {
      const block = event.content_block;
      if (block.type === "text") {
        blocks.push({ type: "text", text: "", index: event.index });
        stream.push({ type: "text_start", contentIndex: blocks.length - 1, partial: output });
      } else if (block.type === "thinking") {
        blocks.push({ type: "thinking", thinking: "", thinkingSignature: "", index: event.index });
        stream.push({ type: "thinking_start", contentIndex: blocks.length - 1, partial: output });
      } else if (block.type === "tool_use") {
        blocks.push({ type: "toolCall", id: block.id, name: block.name, arguments: block.input ?? {}, partialJson: "", index: event.index });
        stream.push({ type: "toolcall_start", contentIndex: blocks.length - 1, partial: output });
      }
    } else if (event.type === "content_block_delta") {
      const index = blocks.findIndex((block) => block.index === event.index);
      const block = blocks[index];
      if (!block) continue;
      if (event.delta.type === "text_delta" && block.type === "text") {
        block.text += event.delta.text;
        stream.push({ type: "text_delta", contentIndex: index, delta: event.delta.text, partial: output });
      } else if (event.delta.type === "thinking_delta" && block.type === "thinking") {
        block.thinking += event.delta.thinking;
        stream.push({ type: "thinking_delta", contentIndex: index, delta: event.delta.thinking, partial: output });
      } else if (event.delta.type === "signature_delta" && block.type === "thinking") {
        block.thinkingSignature += event.delta.signature;
      } else if (event.delta.type === "input_json_delta" && block.type === "toolCall") {
        block.partialJson += event.delta.partial_json;
        try { block.arguments = JSON.parse(block.partialJson); } catch {}
        stream.push({ type: "toolcall_delta", contentIndex: index, delta: event.delta.partial_json, partial: output });
      }
    } else if (event.type === "content_block_stop") {
      const index = blocks.findIndex((block) => block.index === event.index);
      const block = blocks[index];
      if (!block) continue;
      delete block.index;
      if (block.type === "text") stream.push({ type: "text_end", contentIndex: index, content: block.text, partial: output });
      if (block.type === "thinking") stream.push({ type: "thinking_end", contentIndex: index, content: block.thinking, partial: output });
      if (block.type === "toolCall") {
        delete block.partialJson;
        stream.push({ type: "toolcall_end", contentIndex: index, toolCall: block, partial: output });
      }
    } else if (event.type === "message_delta") {
      output.stopReason = event.delta?.stop_reason === "max_tokens" ? "length" : event.delta?.stop_reason === "tool_use" ? "toolUse" : "stop";
      if (event.usage?.output_tokens) output.usage.output = event.usage.output_tokens;
      output.usage.totalTokens = output.usage.input + output.usage.output + output.usage.cacheRead + output.usage.cacheWrite;
    }
  }
}

async function* zedEvents(response: Response): AsyncIterable<any> {
  const reader = response.body?.getReader();
  if (!reader) return;
  const decoder = new TextDecoder();
  let buffer = "";
  for (;;) {
    const { done, value } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });
    let index: number;
    while ((index = buffer.indexOf("\n")) !== -1) {
      const line = buffer.slice(0, index).trim();
      buffer = buffer.slice(index + 1);
      if (!line) continue;
      const item = JSON.parse(line);
      if (item.status) {
        if (item.status.failed) throw new Error(item.status.failed.message);
        continue;
      }
      yield item.event ?? item;
    }
  }
}

async function getAuth(): Promise<Auth> {
  cachedAuth ??= (async () => {
    const { userId, accessToken } = readZedCredentials();
    const systemId = readSystemId();
    const me = await zedFetch<any>("/client/users/me", { auth: { userId, accessToken, organizationId: "" }, systemId });
    const organizationId = process.env.ZED_ORGANIZATION_ID || me.default_organization_id || me.organizations?.[0]?.id;
    if (!organizationId) throw new Error("Zed account has no organization; set ZED_ORGANIZATION_ID");
    return { userId, accessToken, organizationId, systemId };
  })();
  return cachedAuth;
}

function readZedCredentials() {
  if (process.env.ZED_CREDENTIALS) {
    const [userId, ...rest] = process.env.ZED_CREDENTIALS.trim().split(/\s+/);
    return { userId, accessToken: rest.join(" ") };
  }
  if (process.env.ZED_USER_ID && process.env.ZED_ACCESS_TOKEN) {
    return { userId: process.env.ZED_USER_ID, accessToken: process.env.ZED_ACCESS_TOKEN };
  }

  const devCreds = join(homedir(), ".config", "zed", "development_credentials");
  if (existsSync(devCreds)) {
    const entry = JSON.parse(readFileSync(devCreds, "utf8"))[SERVER_URL];
    if (entry) return { userId: entry[0], accessToken: Buffer.from(entry[1]).toString() };
  }

  const accessToken = execFileSync("secret-tool", ["lookup", "url", SERVER_URL], { encoding: "utf8" }).trim();
  const search = execFileSync("gdbus", ["call", "--session", "--dest", "org.freedesktop.secrets", "--object-path", "/org/freedesktop/secrets", "--method", "org.freedesktop.Secret.Service.SearchItems", `{\"url\": \"${SERVER_URL}\"}`], { encoding: "utf8" });
  const item = search.match(/objectpath '([^']+)'/)?.[1];
  if (!item) throw new Error("Zed credentials found, but Secret Service item path was not returned");
  const attrs = execFileSync("gdbus", ["call", "--session", "--dest", "org.freedesktop.secrets", "--object-path", item, "--method", "org.freedesktop.DBus.Properties.Get", "org.freedesktop.Secret.Item", "Attributes"], { encoding: "utf8" });
  const userId = attrs.match(/'username': '([^']+)'/)?.[1];
  if (!userId) throw new Error("Zed credentials found, but username attribute was missing");
  return { userId, accessToken };
}

function readSystemId() {
  try {
    return execFileSync("sqlite3", [join(homedir(), ".local/share/zed/db/0-global/db.sqlite"), "select value from kv_store where key='system_id'"], { encoding: "utf8" }).trim() || undefined;
  } catch {
    return undefined;
  }
}

async function getLlmToken(auth: Auth, force = false) {
  if (force) cachedLlmToken = undefined;
  cachedLlmToken ??= zedFetch<{ token: string }>("/client/llm_tokens", {
    auth,
    systemId: auth.systemId,
    method: "POST",
    body: JSON.stringify({ organization_id: auth.organizationId }),
    headers: { "content-type": "application/json" },
  }).then((response) => response.token);
  return cachedLlmToken;
}

async function zedFetch<T>(path: string, init: ZedInit): Promise<T> {
  const response = await zedFetchResponse(path, init);
  return response.json() as Promise<T>;
}

type ZedInit = RequestInit & { auth: Pick<Auth, "userId" | "accessToken" | "organizationId">; llm?: boolean; systemId?: string };

async function zedFetchResponse(path: string, init: ZedInit, retried = false): Promise<Response> {
  const headers = new Headers(init.headers);
  if (init.llm) {
    headers.set("authorization", `Bearer ${await getLlmToken(init.auth as Auth, retried)}`);
  } else {
    headers.set("authorization", `${init.auth.userId} ${init.auth.accessToken}`);
  }
  if (init.systemId) headers.set("x-zed-system-id", init.systemId);

  const response = await fetch(`${init.llm ? LLM_URL : CLOUD_URL}${path}`, { ...init, headers });
  if (init.llm && !retried && (response.status === 401 || response.headers.has("x-zed-expired-token") || response.headers.has("x-zed-outdated-token"))) {
    return zedFetchResponse(path, init, true);
  }
  if (!response.ok) throw new Error(`Zed ${path} failed (${response.status}): ${await response.text()}`);
  return response;
}

function zedVersionHeader() {
  try {
    const match = execFileSync("zeditor", ["--version"], { encoding: "utf8" }).match(/Zed ([^\s]+)/);
    return match ? { "x-zed-version": match[1] } : {};
  } catch {
    return {};
  }
}
