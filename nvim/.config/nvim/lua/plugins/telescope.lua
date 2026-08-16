return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},

		keys = {
			{
				"<leader><space>",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>,",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Switch Buffers",
			},
			{
				"<leader>/",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Grep Project",
			},
		},

		opts = {
			pickers = {
				find_files = {
					theme = "ivy",
				},
				buffers = {
					theme = "ivy",
				},
				live_grep = {
					theme = "ivy",
				},
			},
		},
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",

		dependencies = {
			"nvim-telescope/telescope.nvim",
		},

		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
}
