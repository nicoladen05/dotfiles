-- Automatic character pairs
return {
	"nvim-mini/mini.pairs",
	version = "0.17.0",
	opts = {
		modes = { insert = true, command = true, terminal = false },
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		skip_ts = { "string" },
		skip_unbalanced = true,
		markdown = true,
	},
	config = function(_, opts)
		local pairs = require("mini.pairs")
		pairs.setup(opts)

		vim.keymap.set("i", "<CR>", function()
			local col = vim.fn.col(".") - 1
			if vim.api.nvim_get_current_line():sub(col, col + 2) == "></" then
				return vim.keycode("<CR><C-o>O<C-i>")
			end
			return pairs.cr()
		end, { expr = true, replace_keycodes = false, desc = "Expand pairs and tags" })
	end,
}
