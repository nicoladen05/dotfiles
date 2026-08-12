return {
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
		-- {
		-- 	"<leader>,",
		-- 	function()
		-- 		require("telescope.builtin")
		-- 	end,
		-- },
	},

	opts = {
		pickers = {
			find_files = {
				theme = "ivy",
			},
		},
	},
}
