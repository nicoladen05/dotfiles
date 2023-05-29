local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },

	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,

}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {

	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {

	"location",
	padding = 0,
}

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox-material',
    --[[ component_separators = { left = '', right = ''}, ]]
    --[[ section_separators = { left = '', right = ''}, ]]
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,

    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {branch, diff, diagnostics},
    lualine_c = {'filename'},
    lualine_x = {filetype},
    lualine_y = {location},
    lualine_z = {progress}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},

    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},

  winbar = {},
  inactive_winbar = {},

  extensions = {}
}
