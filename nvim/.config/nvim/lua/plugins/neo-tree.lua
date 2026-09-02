return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
	},
	cmd = "Neotree",
	opts = {
		use_popups_for_input = false,
		filesystem = {
			follow_current_file = {
				enabled = true,
			},
			use_libuv_file_watcher = true,
			window = {
				mappings = {
					["<CR>"] = "open",
					["n"] = function()
						vim.cmd("normal! j")
					end,
					["e"] = function()
						vim.cmd("normal! k")
					end,
					["i"] = "open",
					["o"] = "close_node",
				},
			},
		},
		window = {
			position = "left",
			width = 35,
		},
	},
	keys = {
		{
			"<leader>e",
			function()
				require("neo-tree.command").execute({
					toggle = true,
				})
			end,
			desc = "File Explorer",
		},
	},
}
