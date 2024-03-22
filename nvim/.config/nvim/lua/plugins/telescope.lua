local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
return
end

local actions = require "telescope.actions"

telescope.setup {
defaults = {

vimgrep_arguments = {
  "rg",
  "-L",
  "--color=never",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--column",
  "--smart-case",
},
prompt_prefix = "   ",
selection_caret = "  ",
entry_prefix = "  ",
initial_mode = "insert",
selection_strategy = "reset",
sorting_strategy = "ascending",
layout_strategy = "horizontal",
layout_config = {
  horizontal = {
    prompt_position = "top",
    preview_width = 0.55,
    results_width = 0.8,
  },
  vertical = {
    mirror = false,
  },
  width = 0.87,
  height = 0.80,
  preview_cutoff = 120,
},
file_sorter = require("telescope.sorters").get_fuzzy_file,
file_ignore_patterns = { "node_modules" },
generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
path_display = { "truncate" },
winblend = 0,
border = {},
borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
color_devicons = true,
set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
file_previewer = require("telescope.previewers").vim_buffer_cat.new,
grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
-- Developer configurations: Not meant for general override
buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,

mappings = {
  i = {
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,

    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,

    ["<C-c>"] = actions.close,

    ["<Down>"] = actions.move_selection_next,
    ["<Up>"] = actions.move_selection_previous,

    ["<CR>"] = actions.select_default,
    ["<C-x>"] = actions.select_horizontal,
    ["<C-v>"] = actions.select_vertical,
    ["<C-t>"] = actions.select_tab,

    ["<C-u>"] = actions.preview_scrolling_up,
    ["<C-d>"] = actions.preview_scrolling_down,

    ["<PageUp>"] = actions.results_scrolling_up,
    ["<PageDown>"] = actions.results_scrolling_down,

    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
    ["<C-l>"] = actions.complete_tag,
    ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
  },

  n = {
    ["<esc>"] = actions.close,
    ["<CR>"] = actions.select_default,
    ["<C-x>"] = actions.select_horizontal,
    ["<C-v>"] = actions.select_vertical,
    ["<C-t>"] = actions.select_tab,

    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

    ["j"] = actions.move_selection_next,
    ["k"] = actions.move_selection_previous,
    ["H"] = actions.move_to_top,
    ["M"] = actions.move_to_middle,
    ["L"] = actions.move_to_bottom,

    ["<Down>"] = actions.move_selection_next,
    ["<Up>"] = actions.move_selection_previous,
    ["gg"] = actions.move_to_top,
    ["G"] = actions.move_to_bottom,

    ["<C-u>"] = actions.preview_scrolling_up,
    ["<C-d>"] = actions.preview_scrolling_down,

    ["<PageUp>"] = actions.results_scrolling_up,
    ["<PageDown>"] = actions.results_scrolling_down,

    ["?"] = actions.which_key,
  },
},
},
pickers = {
-- Default configuration for builtin pickers goes here:
-- picker_name = {
--   picker_config_key = value,
--   ...
-- }
-- Now the picker_config_key will be applied every time you call this
-- builtin picker
},
extensions = {
-- Your extension configuration goes here:
   gitmoji = {
      action = function(entry)
          -- entry = {
          --   display = "🐛 Fix a bug.",
          --   index = 4,
          --   ordinal = "Fix a bug.",
          --   value = {
          --     description = "Fix a bug.",
          --     text = ":bug:",
          --     value = "🐛"
          --   }
          -- }
          local emoji = entry.value.value
          vim.ui.input({ prompt = "Enter commit message: " .. emoji .. " "}, function(msg)
              if not msg then
                  return
              end
              -- Insert text instead of emoji in message
              local emoji_text = entry.value.text
              vim.cmd(':silent !git add % && git commit -m "' .. emoji_text .. ' ' .. msg .. '"')
          end)
      end,
    },
-- extension_name = {
--   extension_config_key = value,
-- }
-- please take a look at the readme of the extension you want to configure
},
}
