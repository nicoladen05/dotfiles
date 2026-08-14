-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Interface
vim.opt.termguicolors = true

-- Mouse
vim.opt.mouse = "a"

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
