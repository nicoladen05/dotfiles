-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Custom normal-mode layout: h n e i = left down up right.
vim.keymap.set("n", "n", "j")
vim.keymap.set("n", "e", "k")
vim.keymap.set("n", "i", "l")

-- Move displaced normal-mode commands.
vim.keymap.set("n", "k", "i")
vim.keymap.set("n", "j", "n")
vim.keymap.set("n", "l", "e")

-- Keep the selection active when changing indentation.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
