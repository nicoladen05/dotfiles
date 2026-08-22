local add_prettier_formatters = function(formatter_spec)
	local prettier_supported_languages = {
		"javascript",
		"typescript",
		"css",
		"html",
		"svelte",
		"json",
		"markdown",
		"yaml",
	}

	local prettier_spec = { "prettierd", "prettier", stop_after_first = true }

	for _, language in ipairs(prettier_supported_languages) do
		formatter_spec[language] = prettier_spec
	end
end

local formatter_spec = {
	lua = { "stylua" },
	python = { "isort", "black" },
}

add_prettier_formatters(formatter_spec)

return {
	"stevearc/conform.nvim",

	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	opts = {
		formatters_by_ft = formatter_spec,

		format_on_save = { timeout_ms = 500 },

		default_format_opts = {
			lsp_format = "fallback",
		},
	},

	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format",
		},
	},
}
