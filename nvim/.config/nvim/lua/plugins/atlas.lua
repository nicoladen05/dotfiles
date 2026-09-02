return {
	"emrearmagan/atlas.nvim",
	cmd = { "Atlas", "AtlasDiff" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {},
		},
	},
	keys = {
		{ "<leader>aa", "<cmd>Atlas<cr>", desc = "Atlas Actions" },
		{ "<leader>ap", "<cmd>Atlas pulls github<cr>", desc = "Atlas Pull Requests" },
		{ "<leader>ai", "<cmd>Atlas issues github<cr>", desc = "Atlas Issues" },
		{ "<leader>ar", "<cmd>Atlas review<cr>", desc = "Atlas Review Pull Request" },
		{ "<leader>as", "<cmd>Atlas search github<cr>", desc = "Atlas Search GitHub" },
		{ "<leader>ao", "<cmd>Atlas open .<cr>", desc = "Atlas Open Repository" },
		{ "<leader>acp", "<cmd>Atlas create pr<cr>", desc = "Atlas Create Pull Request" },
		{ "<leader>aci", "<cmd>Atlas create issue<cr>", desc = "Atlas Create Issue" },
	},
	opts = {},
}
