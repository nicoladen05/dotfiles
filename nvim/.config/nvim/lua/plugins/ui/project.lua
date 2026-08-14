return {
	"DrKJeff16/project.nvim",
	cmd = { "Project" },

	opts = {},

	keys = {
		{
			"<leader>fp",
			function()
				require("telescope").extensions.projects.projects(require("telescope.themes").get_ivy())
			end,
			desc = "Find Projects",
		},
	},
}
