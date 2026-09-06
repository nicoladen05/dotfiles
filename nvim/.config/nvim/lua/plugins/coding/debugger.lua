return {
	{
		"mfussenegger/nvim-dap",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			local js_debug_adapter = {
				type = "server",
				host = "127.0.0.1",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
					args = { "${port}", "127.0.0.1" },
				},
			}

			for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
				dap.adapters[adapter] = js_debug_adapter
			end

			local skip_files = {
				"<node_internals>/**",
				"${workspaceFolder}/node_modules/**",
			}
			local node_configurations = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch current file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = skip_files,
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to Node process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = skip_files,
				},
			}
			local browser_configuration = {
				type = "pwa-chrome",
				request = "launch",
				name = "Launch browser",
				url = function()
					return vim.fn.input("URL: ", "http://localhost:5173")
				end,
				webRoot = "${workspaceFolder}",
				sourceMaps = true,
			}

			for _, filetype in ipairs({ "javascript", "typescript" }) do
				dap.configurations[filetype] = vim.list_extend(vim.deepcopy(node_configurations), {
					vim.deepcopy(browser_configuration),
				})
			end

			for _, filetype in ipairs({ "javascriptreact", "typescriptreact", "svelte" }) do
				dap.configurations[filetype] = { vim.deepcopy(browser_configuration) }
			end

			dapui.setup()

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,

		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Set Conditional Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue Debugging",
			},
			{
				"<leader>dn",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate Debugging",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle Debug REPL",
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Debug Hover",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "x" },
				desc = "Evaluate Expression",
			},
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
		event = "VeryLazy",

		dependencies = {
			"mfussenegger/nvim-dap",
			"mason-org/mason.nvim",
		},

		cmd = { "DapInstall", "DapUninstall" },

		opts = {
			ensure_installed = { "js", "delve" },
			handlers = {},
		},
	},
}
