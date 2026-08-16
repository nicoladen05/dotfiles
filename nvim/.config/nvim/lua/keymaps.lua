-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Colemak layout: h n e i = left down up right.
vim.keymap.set({ "n", "v", "o" }, "n", "j")
vim.keymap.set({ "n", "v", "o" }, "e", "k")
vim.keymap.set({ "n", "v", "o" }, "i", "l")
vim.keymap.set({ "n", "v", "o" }, "N", "J")
vim.keymap.set({ "n", "v", "o" }, "E", vim.lsp.buf.hover)
vim.keymap.set({ "n", "v", "o" }, "I", "L")

-- Remap movments between windows
vim.keymap.set({ "n", "v", "o" }, "<C-w>n", "<C-w>j")
vim.keymap.set({ "n", "v", "o" }, "<C-w>e", "<C-w>k")
vim.keymap.set({ "n", "v", "o" }, "<C-w>i", "<C-w>l")
vim.keymap.set({ "n", "v", "o" }, "<C-w><C-n>", "<C-w>j")
vim.keymap.set({ "n", "v", "o" }, "<C-w><C-e>", "<C-w>k")
vim.keymap.set({ "n", "v", "o" }, "<C-w><C-i>", "<C-w>l")

-- Move displaced normal-mode commands.
vim.keymap.set({ "n", "v", "o" }, "k", "i")
vim.keymap.set({ "n", "v", "o" }, "j", "n")
vim.keymap.set({ "n", "v", "o" }, "l", "e")
vim.keymap.set({ "n", "v", "o" }, "K", "I")
vim.keymap.set({ "n", "v", "o" }, "J", "N")
vim.keymap.set({ "n", "v", "o" }, "L", "E")

-- Keep the selection active when changing indentation.
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- Better LSP Bindings
vim.keymap.set({ "n", "v" }, "g.", vim.lsp.buf.code_action)
vim.keymap.set({ "n", "v" }, "gd", vim.lsp.buf.definition)

-- Navigate quickfix/location list
vim.keymap.set({ "n", "v" }, "<M-n>", "<cmd>cnext<cr>")
vim.keymap.set({ "n", "v" }, "<M-e>", "<cmd>cprev<cr>")
