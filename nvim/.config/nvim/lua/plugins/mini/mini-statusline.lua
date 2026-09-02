return {
	"nvim-mini/mini.statusline",
	version = false,
	config = function()
		local statusline = require("mini.statusline")

		statusline.setup({
			content = {
				active = function()
					local mode, mode_hl = statusline.section_mode({ trunc_width = 80 })
					local git = statusline.section_git({ trunc_width = 40 })
					local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
					local filename = statusline.section_filename({ trunc_width = 120 })
					local location = statusline.section_location({ trunc_width = 40 })

					return statusline.combine_groups({
						{ hl = mode_hl, strings = { mode } },
						{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
						"%<",
						{ hl = "MiniStatuslineFilename", strings = { filename } },
						"%=",
						{ hl = mode_hl, strings = { location } },
					})
				end,
				inactive = function()
					return statusline.combine_groups({
						{ hl = "MiniStatuslineInactive", strings = { statusline.section_filename({}) } },
					})
				end,
			},
		})
	end,
}
