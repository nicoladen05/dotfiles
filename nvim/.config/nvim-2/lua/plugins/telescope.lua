local builtin = require("telescope.builtin")

-- Keymaps
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>ft', builtin.live_grep, {})
