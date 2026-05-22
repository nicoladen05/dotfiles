import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

const CODEX_ACCOUNT_ID_CLAIM = "https://api.openai.com/auth.chatgpt_account_id";

function isCodexProvider(provider: string | undefined): boolean {
  return /^openai-codex(-\d+)?$/.test(provider ?? "");
}

function decodeJwtPayload(token: string): Record<string, unknown> {
  const parts = token.split(".");

  if (parts.length < 2) return {};

  try {
    return JSON.parse(
      Buffer.from(parts[1]!, "base64url").toString("utf-8"),
    ) as Record<string, unknown>;
  } catch {
    return {};
  }
}

function getOpenAiAccountId(token: string): string | undefined {
  const payload = decodeJwtPayload(token);

  return typeof payload[CODEX_ACCOUNT_ID_CLAIM] === "string"
    ? payload[CODEX_ACCOUNT_ID_CLAIM]
    : undefined;
}

async function fetchCodexUsage(
  ctx: ExtensionContext,
): Promise<{ main: number; weekly: number } | undefined> {
  const model = ctx.model;

  if (
    !model ||
    !isCodexProvider(model.provider) ||
    !ctx.modelRegistry.isUsingOAuth(model)
  )
    return;

  const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);

  if (!auth.ok || !auth.apiKey) return;

  const accountId = getOpenAiAccountId(auth.apiKey ?? "");

  const response = await fetch("https://chatgpt.com/backend-api/wham/usage", {
    headers: {
      Authorization: `Bearer ${auth.apiKey}`,
      Accept: "application/json",
      "User-Agent": "pi-codex-usage",
      ...(accountId ? { "chatgpt-account-id": accountId } : {}),
    },
  });

  if (!response.ok) return;

  const data = await response.json();

  return {
    main: data.rate_limit.primary_window.used_percent,
    weekly: data.rate_limit.secondary_window.used_percent,
  };
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    const usage = await fetchCodexUsage(ctx);

    if (!usage) return;

    ctx.ui.setStatus(
      "codex-usage",
      ctx.ui.theme.fg("dim", `main: ${usage.main}%, weekly: ${usage.weekly}%`),
    );
  });
}
