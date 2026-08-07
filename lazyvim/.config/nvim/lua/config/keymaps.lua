-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Colemak movement
map({ "n", "x", "o" }, "h", "h", { desc = "Left" })
map({ "n", "x", "o" }, "n", "j", { desc = "Down" })
map({ "n", "x", "o" }, "e", "k", { desc = "Up" })
map({ "n", "x", "o" }, "i", "l", { desc = "Right" })
map({ "n", "x", "o" }, "j", "n", { desc = "Next Search Result" })
map({ "n", "x", "o" }, "J", "N", { desc = "Previous Search Result" })
map({ "n", "x", "o" }, "l", "e", { desc = "End of Word" })
map({ "n", "x", "o" }, "L", "E", { desc = "End of WORD" })
map({ "x", "o" }, "I", "L", { desc = "Bottom of Window" })

-- I takes over LazyVim's <S-l> next-buffer mapping, since l is now End of Word.
-- H is untouched, so it still steps to the previous buffer.
map("n", "I", "<cmd>bnext<cr>", { desc = "Next Buffer" })

map("n", "k", "i", { desc = "Insert" })
map({ "n", "x" }, "N", "J", { desc = "Join Lines" })
map("n", "K", "I", { desc = "Insert at Start of Line" })
map("x", "K", "<Esc>i", { desc = "Insert" })
-- Fallback for buffers with no LSP client. With a client attached,
-- lua/plugins/lsp-colemak-keys.lua overrides E with LSP hover.
map({ "n", "x" }, "E", "K", { desc = "Keyword Lookup" })

-- Use k as the inner-text-object prefix while an operator is pending or a visual
-- selection is active (for example, dkw and vk(). K still starts insert from visual mode.
map({ "o", "x" }, "k", "i", { desc = "Inner Text Object" })

-- Colemak movement after the window command prefix.
map("n", "<C-w>h", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-w><C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-w>n", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-w><C-n>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-w>e", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-w><C-e>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-w>i", "<C-w>l", { desc = "Go to Right Window" })
map("n", "<C-w><C-i>", "<C-w>l", { desc = "Go to Right Window" })

-- Neo-tree installs buffer-local mappings after FileType, so apply its Colemak
-- navigation on the next event-loop tick. h is already Neo-tree's close-node key.
local function set_neo_tree_keymaps(buf)
  map("n", "n", "j", { buffer = buf, desc = "Down" })
  map("n", "e", "k", { buffer = buf, desc = "Up" })
  map("n", "i", "l", { buffer = buf, desc = "Open", remap = true })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function(event)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(event.buf) then
        set_neo_tree_keymaps(event.buf)
      end
    end)
  end,
})

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.bo[buf].filetype == "neo-tree" then
    set_neo_tree_keymaps(buf)
  end
end
