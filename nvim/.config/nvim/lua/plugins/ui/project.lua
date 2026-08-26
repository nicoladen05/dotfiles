return {
	"DrKJeff16/project.nvim",
	cmd = { "Project" },

	opts = {},

	keys = {
		{
			"<leader>fp",
			function()
				require("telescope").extensions.projects.projects()
			end,
			desc = "Find Projects",
		},
	},
}
