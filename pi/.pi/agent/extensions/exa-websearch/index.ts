import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { StringEnum, Type } from "@earendil-works/pi-ai";
import { defineTool, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

const execFileAsync = promisify(execFile);

async function getApiKey(signal?: AbortSignal): Promise<string> {
  try {
    const { stdout } = await execFileAsync(
      "secret-tool",
      ["lookup", "service", "exa", "application", "pi"],
      { encoding: "utf8", signal },
    );
    const apiKey = stdout.trim();
    if (apiKey) return apiKey;
  } catch (error) {
    if (signal?.aborted) throw error;
  }

  throw new Error("Exa API key not found in the keyring. Store it with secret-tool using attributes: service exa application pi.");
}

type ExaResponse = {
  requestId?: string;
  costDollars?: { total?: number };
  results?: Array<{
    title?: unknown;
    url?: unknown;
    publishedDate?: unknown;
    author?: unknown;
    highlights?: unknown;
  }>;
};

const text = (value: unknown, max: number) =>
  typeof value === "string" ? value.replace(/\s+/g, " ").trim().slice(0, max) : "";

export function formatResults(data: ExaResponse, query: string): string {
  if (!Array.isArray(data.results)) throw new Error("Exa returned an invalid response");
  if (data.results.length === 0) return `No results found for: ${query}`;

  return data.results
    .map((result, index) => {
      const title = text(result.title, 300) || "Untitled";
      const url = text(result.url, 1000);
      const metadata = [text(result.publishedDate, 50), text(result.author, 200)].filter(Boolean).join(" — ");
      const highlights = Array.isArray(result.highlights)
        ? result.highlights.slice(0, 2).map((item) => text(item, 800)).filter(Boolean)
        : [];

      return [
        `${index + 1}. ${title}`,
        url,
        metadata,
        ...highlights.map((highlight) => `   ${highlight}`),
      ].filter(Boolean).join("\n");
    })
    .join("\n\n");
}

const exaSearch = defineTool({
  name: "exa_search",
  label: "Exa Search",
  description: "Search the web with Exa and return up to 10 results with URLs and relevant excerpts.",
  promptSnippet: "Search the web with Exa for current information and relevant sources",
  promptGuidelines: [
    "Use exa_search when the task needs current web information, external sources, or facts not available in the local project.",
  ],
  parameters: Type.Object({
    query: Type.String({ description: "Natural-language web search query" }),
    numResults: Type.Optional(Type.Integer({ minimum: 1, maximum: 10, description: "Number of results (default: 5)" })),
    type: Type.Optional(StringEnum(["auto", "fast", "instant"] as const, { description: "Search mode (default: auto)" })),
    includeDomains: Type.Optional(Type.Array(Type.String(), { maxItems: 20, description: "Only search these domains" })),
    excludeDomains: Type.Optional(Type.Array(Type.String(), { maxItems: 20, description: "Exclude these domains" })),
    startPublishedDate: Type.Optional(Type.String({ description: "Only results published after this ISO 8601 date" })),
    endPublishedDate: Type.Optional(Type.String({ description: "Only results published before this ISO 8601 date" })),
    maxAgeHours: Type.Optional(Type.Integer({ minimum: -1, description: "Maximum cached-content age; 0 forces live crawl, -1 uses cache only" })),
  }),

  async execute(_toolCallId, params, signal) {
    const apiKey = await getApiKey(signal);

    const response = await fetch("https://api.exa.ai/search", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        query: params.query,
        type: params.type ?? "auto",
        numResults: params.numResults ?? 5,
        includeDomains: params.includeDomains,
        excludeDomains: params.excludeDomains,
        startPublishedDate: params.startPublishedDate,
        endPublishedDate: params.endPublishedDate,
        contents: {
          highlights: { maxCharacters: 1600 },
          maxAgeHours: params.maxAgeHours,
        },
      }),
      signal,
    });

    if (!response.ok) {
      const body = text(await response.text(), 500);
      throw new Error(`Exa search failed (${response.status}): ${body || response.statusText}`);
    }

    const data = await response.json() as ExaResponse;
    return {
      content: [{ type: "text", text: formatResults(data, params.query) }],
      details: { requestId: data.requestId, costDollars: data.costDollars?.total },
    };
  },
});

export default function (pi: ExtensionAPI) {
  pi.registerTool(exaSearch);
}
