return {
	"nvim-treesitter/nvim-treesitter",

	-- Treesitter does not support lazyloading
	lazy = false,

	build = ":TSUpdate",

	opts = {
		indent = { enable = true },
		highlight = { enable = true },
		ensure_installed = {
			"bash",
			"c",
			"css",
			"diff",
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

	config = function(_, opts)
		local treesitter = require("nvim-treesitter")

		treesitter.setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),

			callback = function(args)
				local language = vim.treesitter.language.get_lang(args.match)

				if not language then
					return
				end

				local parser = vim.api.nvim_get_runtime_file("parser/" .. language .. ".*", false)[1]

				if parser then
					vim.treesitter.start(args.buf, language)
					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
					vim.wo[0][0].foldlevel = 99
				end
			end,
		})
	end,
}
