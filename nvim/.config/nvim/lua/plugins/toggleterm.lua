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
}
