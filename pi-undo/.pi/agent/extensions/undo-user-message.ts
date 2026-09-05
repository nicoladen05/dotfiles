import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

type SessionEntry = ReturnType<ExtensionContext["sessionManager"]["getBranch"]>[number];

function findLastUserMessage(entries: SessionEntry[]) {
  return entries.findLast((entry) => entry.type === "message" && entry.message.role === "user");
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("undo", {
    description: "Undo the last user message",
    handler: async (_args, ctx) => {
      const message = findLastUserMessage(ctx.sessionManager.getBranch());
      if (!message) return ctx.ui.notify("No user message to undo", "info");
      await ctx.navigateTree(message.id);
    },
  });

  pi.registerShortcut("alt+u", {
    description: "Undo the last user message",
    handler: (ctx) => {
      if (ctx.ui.getEditorText().trim()) return ctx.ui.notify("Clear the current draft before undoing", "warning");
      if (ctx.isIdle()) {
        pi.sendUserMessage("/undo", { expandPromptTemplates: true });
        return;
      }
      ctx.abort();
      pi.sendUserMessage("/undo", { deliverAs: "followUp", expandPromptTemplates: true });
    },
  });
}

if (import.meta.main) {
  const entries = [
    { type: "message", id: "first", message: { role: "user" } },
    { type: "message", id: "reply", message: { role: "assistant" } },
    { type: "message", id: "last", message: { role: "user" } },
  ] as unknown as SessionEntry[];
  if (findLastUserMessage(entries)?.id !== "last" || findLastUserMessage([]) !== undefined) throw new Error("self-check failed");
}
