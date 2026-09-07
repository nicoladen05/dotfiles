-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Interface
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Mouse
vim.opt.mouse = "a"

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.hl_op({ higroup = "Visual", timeout = 200 })
	end,
})

-- Persistent undo
vim.opt.undofile = true

-- System clipboard as default register
vim.opt.clipboard = "unnamedplus"

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0 -- Default to the tabstop value.

-- Better splits
vim.opt.splitbelow = true
vim.opt.splitright = true
