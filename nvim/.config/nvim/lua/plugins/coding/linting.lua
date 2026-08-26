return {
	"mfussenegger/nvim-lint",

	event = { "BufReadPost", "BufNewFile" },

	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			sh = { "shellcheck" },
			python = { "ruff" },
			markdown = { "markdownlint-cli2" },
		}

		local lint_group = vim.api.nvim_create_augroup("user-lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = lint_group,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
