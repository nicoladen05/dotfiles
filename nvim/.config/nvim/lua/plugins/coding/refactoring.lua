return {
	"ThePrimeagen/refactoring.nvim",

	dependencies = {
		"lewis6991/async.nvim",
	},

	cmd = "Refactor",

	opts = {},

	keys = {
		{
			"<leader>r",
			function()
				require("refactoring").select_refactor()
			end,
			desc = "Refactor",
			mode = { "n", "v" },
		},
	},
}
