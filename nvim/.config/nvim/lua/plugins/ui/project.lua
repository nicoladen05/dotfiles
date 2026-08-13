return {
	"ahmedkhalf/project.nvim",

	-- Detection runs off VimEnter/BufEnter autocmds registered in setup(),
	-- so this has to be loaded at startup to see opened buffers.
	lazy = false,

	config = function()
		require("project_nvim").setup()
	end,

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
