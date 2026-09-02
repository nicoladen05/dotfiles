return {
	"neovim/nvim-lspconfig",

	dependencies = {
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},

	config = function()
		local lsp_group = vim.api.nvim_create_augroup("user-lsp", { clear = true })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_group,
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				local bufnr = event.buf

				if not client then
					return
				end

				local function buffer_map(modes, lhs, rhs, desc)
					vim.keymap.set(modes, lhs, rhs, {
						buffer = bufnr,
						desc = "LSP: " .. desc,
						silent = true,
					})
				end

				local function lsp_map(method, modes, lhs, rhs, desc)
					if client:supports_method(method, bufnr) then
						buffer_map(modes, lhs, rhs, desc)
					end
				end

				lsp_map("textDocument/hover", "n", "E", vim.lsp.buf.hover, "Hover")
				lsp_map("textDocument/definition", "n", "gd", function()
					Snacks.picker.lsp_definitions()
				end, "Goto Definition")
				lsp_map("textDocument/references", "n", "gr", function()
					Snacks.picker.lsp_references()
				end, "References")
				lsp_map("textDocument/implementation", "n", "gI", function()
					Snacks.picker.lsp_implementations()
				end, "Goto Implementation")
				lsp_map("textDocument/declaration", "n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
				lsp_map("textDocument/typeDefinition", "n", "gy", function()
					Snacks.picker.lsp_type_definitions()
				end, "Goto Type Definition")

				lsp_map("textDocument/rename", "n", "grn", vim.lsp.buf.rename, "Rename")
				lsp_map("textDocument/signatureHelp", "n", "gK", vim.lsp.buf.signature_help, "Signature Help")
				lsp_map("textDocument/signatureHelp", "i", "<C-s>", vim.lsp.buf.signature_help, "Signature Help")
				lsp_map("textDocument/codeAction", { "n", "x" }, "g.", vim.lsp.buf.code_action, "Code Action")
				lsp_map("textDocument/codeAction", { "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")

				lsp_map("textDocument/documentSymbol", "n", "<leader>fs", function()
					Snacks.picker.lsp_symbols({ tree = false, filter = { default = true } })
				end, "Document Symbols")
				lsp_map("workspace/symbol", "n", "<leader>fS", function()
					Snacks.picker.lsp_workspace_symbols({ filter = { default = true } })
				end, "Workspace Symbols")

				lsp_map("textDocument/prepareCallHierarchy", "n", "gai", vim.lsp.buf.incoming_calls, "Incoming Calls")
				lsp_map("textDocument/prepareCallHierarchy", "n", "gao", vim.lsp.buf.outgoing_calls, "Outgoing Calls")

				lsp_map("textDocument/codeLens", { "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Code Lens")
				lsp_map("textDocument/codeLens", "n", "<leader>cC", function()
					local enabled = vim.lsp.codelens.is_enabled({ bufnr = bufnr })
					vim.lsp.codelens.enable(not enabled, { bufnr = bufnr })
				end, "Toggle Code Lens")
				lsp_map("textDocument/codeAction", "n", "<leader>co", function()
					vim.lsp.buf.code_action({
						context = { only = { "source.organizeImports" } },
						apply = true,
					})
				end, "Organize Imports")

				lsp_map("textDocument/inlayHint", "n", "<leader>uh", function()
					local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
					vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
				end, "Toggle Inlay Hints")

				buffer_map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
				buffer_map("n", "]d", function()
					vim.diagnostic.jump({ count = 1 })
				end, "Next Diagnostic")
				buffer_map("n", "[d", function()
					vim.diagnostic.jump({ count = -1 })
				end, "Previous Diagnostic")
			end,
		})

		vim.diagnostic.config({
			virtual_text = { current_line = true },
			signs = true,
			underline = true,
		})
	end,
}
