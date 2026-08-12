return {
	"lewis6991/gitsigns.nvim",

	config = function()
		-- Fix colorscheme
		vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiffAdd" })
		vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiffChange" })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiffDelete" })
	end,

	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},

		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},

		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			vim.keymap.set(
				{ "n", "x" },
				"<leader>ghs",
				"<cmd>Gitsigns stage_hunk<cr>",
				{ buffer = buffer, silent = true, desc = "Stage hunk" }
			)
			vim.keymap.set(
				{ "n", "x" },
				"<leader>ghr",
				"<cmd>Gitsigns reset_hunk<cr>",
				{ buffer = buffer, silent = true, desc = "Reset hunk" }
			)
			vim.keymap.set(
				"n",
				"<leader>ghu",
				gs.undo_stage_hunk,
				{ buffer = buffer, silent = true, desc = "Undo stage hunk" }
			)
			vim.keymap.set(
				"n",
				"<leader>ghp",
				gs.preview_hunk_inline,
				{ buffer = buffer, silent = true, desc = "Preview hunk" }
			)
		end,
	},
}
