local opt = vim.opt
local g = vim.g
local key = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }


-------------
-- OPTIONS --
-------------
-- Undo files
opt.undofile = true
opt.undodir = "/home/nico/.cache"

-- Indentation
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.shiftwidth = 2

-- System clipboard
opt.clipboard = "unnamedplus"

-- Colors
opt.termguicolors = true

-- Use mouse
opt.mouse = "a"

-- UI
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

-- Viminfo
opt.viminfo = ""
opt.viminfofile = "NONE"

-- Quality of life
-- opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
-- opt.autoread = true
-- opt.backup = false
-- opt.compatible = false
-- opt.errorbells = false
-- opt.hidden = true
-- opt.incsearch = true
-- opt.shell = "zsh"
-- opt.shortmess = "atI"
-- opt.showmode = false
-- opt.smartcase = true
-- opt.swapfile = false
-- opt.ttimeoutlen = 5
-- opt.wrap = false
-- opt.writebackup = false


--------------
-- KEYBINDS __
--------------

-- Leader key
g.mapleader = ' '
g.maplocalleader = ' '

-- Better window navigation
key("n", "<C-h>", "<C-w>h", opts)
key("n", "<C-n>", "<C-w>j", opts)
key("n", "<C-e>", "<C-w>k", opts)
key("n", "<C-i>", "<C-w>l", opts)

-- Resize with arrows
key("n", "<C-Up>", ":resize -2<CR>", opts)
key("n", "<C-Down>", ":resize +2<CR>", opts)
key("n", "<C-Left>", ":vertical resize -2<CR>", opts)
key("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
key("n", "<S-i>", ":bnext<CR>", opts)
key("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --

-- Visual --
-- Stay in indent mode
key("v", ">", ">gv", opts)
key("v", "<", "<gv", opts)

-- Remaps for colemak
key("n", "n", "j", opts)
key("n", "e", "k", opts)
key("n", "i", "l", opts)
key("n", "k", "i", opts)
key("n", "j", "n", opts)
key("n", "l", "e", opts)

key("v", "n", "j", opts)
key("v", "e", "k", opts)
key("v", "i", "l", opts)
key("v", "k", "i", opts)
key("v", "j", "n", opts)
key("v", "l", "e", opts)
