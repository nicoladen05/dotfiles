return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	ft = { "org" },
	dependencies = {
		{ "nvim-orgmode/org-bullets.nvim", opts = {} },
		{
			"nvim-orgmode/telescope-orgmode.nvim",
			dependencies = { "folke/snacks.nvim" },
			keys = {
				{
					"<leader>or",
					function()
						require("telescope-orgmode").refile_heading()
					end,
					desc = "Org Refile",
				},
			},
			opts = { adapter = "snacks" },
		},
	},
	opts = {
		org_agenda_files = "~/org/*.org",
		org_default_notes_file = "~/org/inbox.org",
		org_capture_templates = {
			n = {
				description = "Note",
				target = "~/org/notes.org",
				template = "* %? %u\n",
			},
		},
		mappings = {
			org = { org_refile = false },
		},
		ui = {
			input = { use_vim_ui = true },
		},
	},
}
