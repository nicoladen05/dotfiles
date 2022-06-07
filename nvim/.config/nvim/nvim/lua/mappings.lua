function hl(highlight, fg, bg)
  cmd("hi " .. highlight .. " guifg=" .. fg .. " guibg=" .. bg)
end

function map(mode, keys, command)
  api.nvim_set_keymap(mode, keys, command, { noremap = true, silent = true })
end

active = false
function minimal()
  if active then
    opt.number = true 
    opt.showmode = false
    opt.showtabline = 2
    opt.laststatus = 2
    opt.signcolumn = 'yes'
    opt.foldcolumn = '0'
  else
    opt.number = false
    opt.showmode = true
    opt.showtabline = 0
    opt.laststatus = 0
    opt.signcolumn = 'no'
    opt.foldcolumn = '1'
  end
  active = not active 
end

-- Normal Map
map("n", "<TAB>", ":bnext<CR>")
map("n", "<S-TAB>", ":bprev<CR>")
map("n", "hs", ":split<CR>")
map("n", "vs", ":vs<CR>")

-- Terminal
map("n", "<leader>v", ":vs +terminal | startinsert<CR>")
map("n", "<leader>h", ":split +terminal | startinsert<CR>")

-- Save
map("i", "<C-S>", "<ESC>:w<CR><Insert>")
map("n", "<C-S>", ":w<CR>")

-- Buffer
map("n", "<leader>x", ":bd<CR>")
map("n", "<leader>s", ":w<CR>")
map("n", "<leader>t", ":enew<CR>")
map("n", "<ESC>", ":nohlsearch<CR>")

-- Minimal toggle
map("n", "<leader>m", ":lua minimal()<CR>")
map("n", "<leader>n", ":set relativenumber!<CR>")

-- Hard update
map("n", "<leader>u", ":tabnew | term cd $HOME/.config/nvim && git reset --hard HEAD && git pull<CR>")

-- Telescope
map("n", "<leader><space>", ":Telescope<CR>")
map("n", "ff", ":Telescope find_files<CR>")

-- NvimTree
map("n", "<C-N>", ":NvimTreeToggle<CR>")
map("n", "<C-B>", ":NvimTreeFocus<CR>")

-- Comment
map("n", "<leader>/", ":lua require('Comment.api').toggle_current_linewise()<CR>")
map("v", "<leader>/", ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")

-- Insert Map
map("i", "<C-E>", "<End>")
map("i", "<C-A>", "<Home>")

-- Shift tab
map("i", "<S-TAB>", "<<<CR>")

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>")
map("n", "<C-Down>", ":resize +2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Toggle term
map("n", "<C-T>", ":ToggleTerm<CR>")
