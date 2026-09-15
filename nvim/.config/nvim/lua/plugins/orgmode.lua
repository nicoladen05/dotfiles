return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	ft = { "org" },
	dependencies = {
		{ "nvim-orgmode/org-bullets.nvim", opts = {} },
	},
	opts = {
		org_agenda_files = "~/org/*.org",
		org_default_notes_file = "~/org/inbox.org",
	},
}
