return {
	"kawre/leetcode.nvim",

	commands = "Leet",

	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},

	opts = {
		lang = "typescript",
		picker = { provider = "telescope" },
	},
}
