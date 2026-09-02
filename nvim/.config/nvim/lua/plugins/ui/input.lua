return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		{
			"<leader><space>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Switch Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep Project",
		},
	},
	opts = {
		input = {
			enabled = true,
			win = {
				relative = "cursor",
				row = 1,
				col = 0,
			},
		},
		picker = {
			enabled = true,
			ui_select = true,
			sources = {
				files = {
					exclude = { "node_modules", "dist" },
				},
				grep = {
					exclude = { "node_modules", "dist" },
				},
				select = {
					kinds = {
						codeaction = {
							layout = {
								layout = {
									relative = "cursor",
									row = 1,
									col = 0,
								},
							},
						},
					},
				},
			},
		},
	},
}
