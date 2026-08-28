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

-- Keep the cursor centered when scrolling half a page.
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Switch between buffers
vim.keymap.set({ "n", "v" }, "<S-h>", "<cmd>bprev<cr>")
vim.keymap.set({ "n", "v" }, "<S-l>", "<cmd>bnext<cr>")

-- Better LSP Bindings
vim.keymap.set({ "n", "v" }, "g.", vim.lsp.buf.code_action)
vim.keymap.set({ "n", "v" }, "gd", vim.lsp.buf.definition)
vim.keymap.set({ "n", "v" }, "<leader>cd", function()
	vim.diagnostic.open_float()
end)

-- Navigate quickfix/location list
vim.keymap.set({ "n", "v" }, "<M-n>", "<cmd>cnext<cr>")
vim.keymap.set({ "n", "v" }, "<M-e>", "<cmd>cprev<cr>")

-- Toggle OpenCode in a persistent bottom split.
local opencode_buf

local function toggle_opencode()
	if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
		local win = vim.fn.bufwinid(opencode_buf)
		if win ~= -1 then
			vim.api.nvim_win_close(win, true)
			return
		end

		vim.cmd("botright 15sbuffer " .. opencode_buf)
	else
		vim.cmd("botright 15new | terminal opencode")
		opencode_buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_create_autocmd("TermClose", {
			buffer = opencode_buf,
			once = true,
			callback = function()
				opencode_buf = nil
			end,
		})
	end

	vim.cmd.startinsert()
end

vim.keymap.set({ "n", "t" }, "<C-/>", toggle_opencode, { desc = "Toggle OpenCode" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_opencode, { desc = "Toggle OpenCode" })
