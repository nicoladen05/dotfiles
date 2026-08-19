return {
	"Cartoone9/pretty-comment.nvim",
	event = "VeryLazy",

	opts = {},

	keys = {
		{
			"<leader>cb",
			"<cmd>CommentBox<cr>",
			mode = { "n", "v" },
			desc = "Comment Box",
			silent = true,
		},
		{
			"<leader>cl",
			"<cmd>CommentLine<cr>",
			mode = { "n", "v" },
			desc = "Comment Line",
			silent = true,
		},
		{
			"<leader>cs",
			"<cmd>CommentSep<cr>",
			mode = { "n", "v" },
			desc = "Comment Seperator",
			silent = true,
		},
		{
			"<leader>cS",
			"<cmd>CommentDivider<cr>",
			mode = { "n", "v" },
			desc = "Comment Divider",
			silent = true,
		},
		{
			"<leader>cd",
			"<cmd>CommentRemove<cr>",
			mode = { "n", "v" },
			desc = "Remove Comment",
			silent = true,
		},
		{
			"<leader>ce",
			"<cmd>CommentEqualize<cr>",
			mode = { "n", "v" },
			desc = "Equalize Comment",
			silent = true,
		},
	},
}
