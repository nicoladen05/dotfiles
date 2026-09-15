-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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

-- Move selected lines down/up.
vim.keymap.set("x", "N", ":move '>+1<cr>gv=gv")
vim.keymap.set("x", "E", ":move '<-2<cr>gv=gv")

-- Keep the selection active when changing indentation.
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- Keep the cursor centered when scrolling half a page.
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Toggle spelling for the current buffer.
vim.keymap.set("n", "<leader>us", "<cmd>setlocal spell!<cr>", { desc = "Toggle spelling" })

-- Switch between buffers
vim.keymap.set({ "n", "v" }, "<S-h>", "<cmd>bprev<cr>")
vim.keymap.set({ "n", "v" }, "<S-l>", "<cmd>bnext<cr>")

-- Better LSP Bindings
vim.keymap.set({ "n", "v" }, "g.", vim.lsp.buf.code_action)
vim.keymap.set({ "n", "v" }, "gd", vim.lsp.buf.definition)
vim.keymap.set({ "n", "v" }, "<leader>cd", function()
	vim.diagnostic.open_float()
end)
vim.keymap.set("n", "<leader>ce", function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local diagnostic = vim.diagnostic.get(0, { lnum = cursor[1] - 1 })[1]
	if not diagnostic then
		vim.notify("No diagnostic on this line", vim.log.levels.INFO)
		return
	end

	local prompt = ("Explain this diagnostic at %s:%d:%d. Explain only; do not change files.\n\n%s"):format(
		vim.api.nvim_buf_get_name(0),
		diagnostic.lnum + 1,
		diagnostic.col + 1,
		diagnostic.message
	)
	local cmd = vim.fn.executable("pi") == 1
		and { "pi", "--model", "openai-codex/gpt-5.6-luna", "--thinking", "medium", prompt }
		or { "opencode", "--prompt", prompt }
	Snacks.terminal.open(cmd, { win = { position = "left", width = 70 } })
end, { desc = "Explain Diagnostic" })

-- Navigate quickfix list
vim.keymap.set({ "n", "v" }, "]c", "<cmd>cnext<cr>")
vim.keymap.set({ "n", "v" }, "[c", "<cmd>cprev<cr>")
