return {
	"tpope/vim-fugitive",

	command = "Git",

	keys = {
		{
			"<leader>gg",
			"<cmd>Git<cr>",
			desc = "Open Fugitive",
		},
		{
			"<leader>ga",
			"<cmd>Git add -A<cr>",
			desc = "Add",
		},
		{
			"<leader>gc",
			"<cmd>Git commit<cr>",
			desc = "Commit",
		},
		{
			"<leader>grbi",
			"<cmd>Git rebase -i<cr>",
			desc = "Interactive Rebase",
		},
		{
			"<leader>gp",
			"<cmd>Git pull --rebase<cr>",
			desc = "Pull",
		},
		{
			"<leader>gP",
			"<cmd>Git push<cr>",
			desc = "Push",
		},
	},
}
