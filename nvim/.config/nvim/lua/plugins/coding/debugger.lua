return {
	{
		"mfussenegger/nvim-dap",

        -- config = function()
        --     local dap = require("dap")
        --
        --     dap.configurations.javascript = {
        --         type = "js-debug-adapter"
        --     }
        --
        -- end

		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue Debugging",
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",

		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},

		opts = {},

		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle Debug UI",
			},
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"mason-org/mason.nvim",
		},

		cmd = { "DapInstall", "DapUninstall" },

		opts = {
			automatic_installation = true,
		},
	},
}
