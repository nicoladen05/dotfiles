return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		direction = "horizontal",
		on_open = function(term)
			vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = term.bufnr, desc = "Leave terminal mode" })
			vim.keymap.set({ "n", "t" }, "<C-c>", function()
				vim.fn.chansend(term.job_id, "\003")
			end, { buffer = term.bufnr, desc = "Interrupt terminal process" })
		end,
		open_mapping = { [[<C-/>]], [[<C-_>]] },
		size = 15,
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		local function toggle_terminal_pair()
			local open = {}
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local id = vim.b[vim.api.nvim_win_get_buf(win)].toggle_number
				if id == 1 or id == 2 then
					open[id] = true
				end
			end

			if open[1] or open[2] then
				for id = 1, 2 do
					if open[id] then
						vim.cmd(id .. "ToggleTerm")
					end
				end
			else
				vim.cmd("1ToggleTerm")
				vim.cmd("2ToggleTerm")
			end
		end

		vim.keymap.set({ "n", "t" }, "<C-S-/>", toggle_terminal_pair, { desc = "Toggle terminal pair" })
	end,
}
