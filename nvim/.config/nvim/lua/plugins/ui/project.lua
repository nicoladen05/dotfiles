return {
	"DrKJeff16/project.nvim",
	cmd = { "Project" },

	opts = {
		snacks = {
			enabled = true,
		},
	},

	keys = {
		{
			"<leader>fp",
			function()
				require("project.extensions.snacks").pick()
			end,
			desc = "Find Projects",
		},
	},
}
