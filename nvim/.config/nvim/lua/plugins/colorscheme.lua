-- Set the current omarchy theme with a fallback if not running omarchy

local theme_file = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

local ok, omarchy_specs = pcall(dofile, theme_file)

-- Fallback theme
if not ok then
	return {
		"tahayvr/matteblack.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("matteblack")
		end,
	}
end

local plugins = {}
local colorscheme

for _, spec in ipairs(omarchy_specs) do
	if spec[1] == "LazyVim/LazyVim" then
		colorscheme = spec.opts and spec.opts.colorscheme
	else
		table.insert(plugins, spec)
	end
end

local theme = plugins[1]
local original_config = theme.config

theme.lazy = false
theme.priority = 1000

theme.config = function(plugin, opts)
	if type(original_config) == "function" then
		original_config(plugin, opts)
	elseif original_config == true or theme.opts ~= nil then
		local loader = require("lazy.core.loader")
		local main = loader.get_main(plugin)

		if main then
			require(main).setup(opts)
		end
	end

	vim.cmd.colorscheme(colorscheme)
end

return plugins
