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

		local function set_highlights()
			local base = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })

			for _, group in ipairs(mode_groups) do
				local mode = vim.api.nvim_get_hl(0, { name = group, link = false })
				vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", base, { fg = mode.bg or base.fg, bold = true }))
			end

			vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { link = "StatusLine" })
			vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { link = "StatusLine" })
			vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { link = "StatusLineNC" })
		end

		statusline.setup({
			content = {
				active = function()
					local mode, mode_hl = statusline.section_mode({ trunc_width = 80 })
					local git = statusline.section_git({ trunc_width = 40 })
					local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
					local filename = statusline.section_filename({ trunc_width = 120 })

					return statusline.combine_groups({
						{ hl = mode_hl, strings = { mode } },
						{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
						"%<",
						{ hl = "MiniStatuslineFilename", strings = { filename } },
						"%=",
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
