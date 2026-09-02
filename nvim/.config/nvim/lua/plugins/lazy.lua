-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local output = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ output, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
	spec = {
		require("plugins.atlas"),
		require("plugins.colorscheme"),
		require("plugins.fugitive"),
		require("plugins.neo-tree"),
		require("plugins.snacks"),

		require("plugins.coding.autotag"),
		require("plugins.coding.completion"),
		require("plugins.coding.copilot"),
		require("plugins.coding.99"),
		require("plugins.coding.debugger"),
		require("plugins.coding.formatting"),
		require("plugins.coding.linting"),
		require("plugins.coding.lsp"),
		require("plugins.coding.mason"),
		require("plugins.coding.refactoring"),
		require("plugins.coding.treesitter"),

		require("plugins.ui.gitsigns"),
		require("plugins.ui.project"),
		require("plugins.ui.trouble"),
		require("plugins.ui.whichkey"),

		require("plugins.mini.mini-comment"),
		require("plugins.mini.mini-pairs"),
		require("plugins.mini.mini-surround"),
	},
	performance = {
		rtp = {
			-- Preserve Ubuntu's multiarch runtime path so Neovim can find its bundled Tree-sitter parsers.
			-- See: https://github.com/folke/lazy.nvim/issues/2177
			reset = false,
		},
	},
})

vim.keymap.set("n", "<leader>l", function()
	require("lazy").show()
end, { desc = "Open Lazy" })
