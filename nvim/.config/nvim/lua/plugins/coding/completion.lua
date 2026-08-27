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

					local suggestion = require("copilot.suggestion")
					if suggestion.is_visible() then
						suggestion.accept()
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
