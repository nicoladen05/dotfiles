return {
	"nvim-mini/mini.statusline",
	version = false,
	config = function()
		local statusline = require("mini.statusline")
		local mode_groups = {
			"MiniStatuslineModeNormal",
			"MiniStatuslineModeInsert",
			"MiniStatuslineModeVisual",
			"MiniStatuslineModeReplace",
			"MiniStatuslineModeCommand",
			"MiniStatuslineModeOther",
		}
		local diagnostic_levels = { "Error", "Warn", "Info", "Hint" }

		local function set_highlights()
			local base = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })

			for _, group in ipairs(mode_groups) do
				local mode = vim.api.nvim_get_hl(0, { name = group, link = false })
				vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", base, { fg = mode.bg or base.fg, bold = true }))
			end
			for _, level in ipairs(diagnostic_levels) do
				local diagnostic = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. level, link = false })
				vim.api.nvim_set_hl(
					0,
					"MiniStatuslineDiagnostic" .. level,
					vim.tbl_extend("force", base, { fg = diagnostic.fg or base.fg })
				)
			end

			vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { link = "StatusLine" })
			vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { link = "StatusLine" })
			vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { link = "StatusLineNC" })
		end

		statusline.setup({
			content = {
				active = function()
					local mode, mode_hl = statusline.section_mode({ trunc_width = math.huge })
					local git = statusline.section_git({ trunc_width = 40 })
					local filename = statusline.section_filename({ trunc_width = 120 })
					local counts = vim.diagnostic.is_enabled({ bufnr = 0 }) and vim.diagnostic.count(0) or {}
					local severity = vim.diagnostic.severity
					local function diagnostic(label, level)
						local count = counts[level] or 0
						return count > 0 and label .. count or ""
					end

					return statusline.combine_groups({
						{ hl = mode_hl, strings = { mode:sub(1, 1) } },
						{ hl = "MiniStatuslineDevinfo", strings = { git } },
						"%<",
						{ hl = "MiniStatuslineFilename", strings = { filename } },
						"%=",
						{ hl = "MiniStatuslineDiagnosticError", strings = { diagnostic("E", severity.ERROR) } },
						{ hl = "MiniStatuslineDiagnosticWarn", strings = { diagnostic("W", severity.WARN) } },
						{ hl = "MiniStatuslineDiagnosticInfo", strings = { diagnostic("I", severity.INFO) } },
						{ hl = "MiniStatuslineDiagnosticHint", strings = { diagnostic("H", severity.HINT) } },
						{ hl = mode_hl, strings = { "%P" } },
					})
				end,
				inactive = function()
					return statusline.combine_groups({
						{ hl = "MiniStatuslineInactive", strings = { statusline.section_filename({}) } },
					})
				end,
			},
		})

		set_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
	end,
}
