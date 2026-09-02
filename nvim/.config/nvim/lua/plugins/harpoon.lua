local keys = {
	{
		"<leader>ha",
		function()
			require("harpoon"):list():add()
		end,
		desc = "Harpoon Add File",
	},
	{
		"<leader>hm",
		function()
			local harpoon = require("harpoon")
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "Harpoon Menu",
	},
}

for index = 1, 8 do
	local item_index = index
	table.insert(keys, {
		"<leader>" .. item_index,
		function()
			require("harpoon"):list():select(item_index)
		end,
		desc = "Harpoon File " .. item_index,
	})
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = keys,
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()
		harpoon:extend(require("harpoon.extensions").builtins.highlight_current_file())
	end,
}
