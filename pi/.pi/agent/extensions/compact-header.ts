import assert from "node:assert/strict";
import { homedir } from "node:os";
import { join, relative, sep } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";

function shortenHome(path: string): string {
	const home = homedir();
	if (path === home) return "~";
	return path.startsWith(`${home}${sep}`) ? `~${sep}${relative(home, path)}` : path;
}

if (process.env.PI_COMPACT_HEADER_SELF_TEST) {
	assert.equal(shortenHome(homedir()), "~");
	assert.equal(shortenHome(join(homedir(), "project")), `~${sep}project`);
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		if (ctx.mode !== "tui") return;

		const result = await pi.exec("git", ["-C", ctx.cwd, "branch", "--show-current"]);
		const branch = (result.code === 0 && result.stdout.trim()) || "—";
		const cwd = shortenHome(ctx.cwd);

		ctx.ui.setHeader((_tui, theme) => ({
			render(width: number): string[] {
				const row = (label: string, value: string, accent = false) =>
					truncateToWidth(
						theme.fg("muted", label.padEnd(8)) + theme.fg(accent ? "accent" : "text", value),
						width,
					);

				return [
					truncateToWidth(theme.fg("accent", "π") + "  " + theme.fg("text", "pi"), width),
					theme.fg("dim", "─".repeat(Math.max(0, Math.min(32, width)))),
					row("cwd", cwd),
					row("git", branch, true),
					row("model", ctx.model?.id ?? "—", true),
				];
			},
			invalidate() {},
		}));
	});
}
