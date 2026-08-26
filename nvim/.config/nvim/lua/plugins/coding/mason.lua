return {
	{
		"mason-org/mason.nvim",
		lazy = false,

		opts = {},

		keys = {
			{ "<leader>cm", "<cmd>Mason<cr>", desc = "Open Mason" },
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",

		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},

		opts = {
			ensure_installed = {
				-- Bash
				"bashls",

				-- CSS
				"cssls",

				-- Lua
				"lua_ls",

				-- Prisma
				"prismals",

				-- Svelte
				"svelte",

				-- Tailwind CSS
				"tailwindcss",

				-- TypeScript
				"vtsls",
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},

		opts = {
			ensure_installed = {
				"eslint_d",
				"markdownlint-cli2",
				"prettierd",
				"ruff",
				"shellcheck",
				"shfmt",
				"stylua",
			},
		},
	},
}
