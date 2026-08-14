return {
	"nvim-treesitter/nvim-treesitter",

	-- Treesitter does not support lazyloading
	lazy = false,

	build = ":TSUpdate",

	opts = {
		indent = { enable = true },
		highlight = { enable = true },
		folds = { enable = true },
		ensure_installed = {
			"bash",
			"c",
			"css",
			"diff",
			"html",
			"html",
			"java",
			"javascript",
			"jsdoc",
			"json",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"svelte",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		},
	},
}
