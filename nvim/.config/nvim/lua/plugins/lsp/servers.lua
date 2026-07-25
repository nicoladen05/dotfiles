local server_configurations = {
    bashls = {},
    cssls = {},
    eslint = {
        settings = {
            workingDirectory = {
                mode = "auto",
            },
        },
    },
    html = {},
    jsonls = function(schemastore)
        return {
            settings = {
                json = {
                    schemas = schemastore.json.schemas(),
                    validate = { enable = true },
                },
            },
        }
    end,
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                hint = {
                    enable = true,
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                    },
                },
            },
        },
    },
    marksman = {},
    svelte = {},
    tailwindcss = {},
    taplo = {},
    ts_ls = {},
    yamlls = function(schemastore)
        return {
            settings = {
                yaml = {
                    schemaStore = {
                        enable = false,
                        url = "",
                    },
                    schemas = schemastore.yaml.schemas(),
                    validate = true,
                },
            },
        }
    end,
}

local function supports(client, method, buffer)
    return client:supports_method(method, buffer)
end

local function configure_lsp()
    vim.diagnostic.config({
        severity_sort = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        virtual_text = {
            source = "if_many",
            spacing = 2,
        },
        float = {
            border = "rounded",
            source = true,
        },
    })

    vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    local schemastore = require("schemastore")
    for server, config in pairs(server_configurations) do
        vim.lsp.config(server, type(config) == "function" and config(schemastore) or config)
    end

    local attach_group = vim.api.nvim_create_augroup("lsp_attach", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = attach_group,
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            local buffer = args.buf

            local function map(modes, lhs, rhs, description)
                vim.keymap.set(modes, lhs, rhs, {
                    buffer = buffer,
                    desc = "LSP: " .. description,
                })
            end

            map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
            map("n", "<leader>le", vim.diagnostic.open_float, "Line diagnostics")
            map("n", "<leader>lh", vim.lsp.buf.hover, "Hover documentation")
            map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
            map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature help")

            if supports(client, "textDocument/inlayHint", buffer) then
                vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
                map("n", "<leader>li", function()
                    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
                    vim.lsp.inlay_hint.enable(not enabled, { bufnr = buffer })
                end, "Toggle inlay hints")
            end

            if supports(client, "textDocument/documentHighlight", buffer) then
                local highlight_group =
                    vim.api.nvim_create_augroup("lsp_highlight_" .. buffer, { clear = true })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    group = highlight_group,
                    buffer = buffer,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    group = highlight_group,
                    buffer = buffer,
                    callback = vim.lsp.buf.clear_references,
                })
                vim.api.nvim_create_autocmd("LspDetach", {
                    group = highlight_group,
                    buffer = buffer,
                    once = true,
                    callback = function()
                        vim.lsp.buf.clear_references()
                    end,
                })
            end
        end,
    })
end

return {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
        {
            "mason-org/mason.nvim",
            keys = {
                {
                    "<leader>lM",
                    "<cmd>Mason<cr>",
                    desc = "LSP: Mason",
                },
            },
            opts = {},
        },
        "neovim/nvim-lspconfig",
        "b0o/SchemaStore.nvim",
        "saghen/blink.cmp",
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                ensure_installed = {
                    "prettier",
                },
                auto_update = false,
                run_on_start = true,
            },
        },
    },
    opts = {
        ensure_installed = {
            "cssls",
            "eslint",
            "html",
            "jsonls",
            "marksman",
            "svelte",
            "tailwindcss",
            "taplo",
            "ts_ls",
            "yamlls",
        },
        automatic_enable = true,
    },
    config = function(_, opts)
        configure_lsp()
        require("mason-lspconfig").setup(opts)
    end,
}
