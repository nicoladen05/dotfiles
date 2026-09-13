return {
	"saghen/blink.cmp",

	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
	},

	build = function()
		---@diagnostic disable-next-line: undefined-field
		require("blink.cmp").build():pwait()
	end,

	opts = {
		keymap = {
			preset = "enter",
			["<Tab>"] = {
				function(cmp)
					if cmp.is_visible() then
						return cmp.accept()
					end

					local suggestion = require("codeium.virtual_text")
					if suggestion.get_current_completion_item() then
						local keys = vim.api.nvim_replace_termcodes(suggestion.accept(), true, false, true)
						vim.api.nvim_feedkeys(keys, "n", false)
						return true
					end

					return false
				end,
				"snippet_forward",
				"fallback",
			},
		},

		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},

		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
		},
	},
}
