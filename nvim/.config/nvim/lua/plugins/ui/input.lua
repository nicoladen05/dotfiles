return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
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
