return {
	"Exafunction/windsurf.nvim",
	event = "InsertEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		enable_cmp_source = false,
		virtual_text = {
			enabled = true,
			map_keys = false,
		},
	},
	config = function(_, opts)
		require("codeium").setup(opts)
	end,
}
