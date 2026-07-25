local formatters_by_filetype = {
    bash = { "shfmt" },
    css = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    jsonc = { "prettierd", "prettier", stop_after_first = true },
    lua = { "stylua" },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    sh = { "shfmt" },
    svelte = { "prettierd", "prettier", stop_after_first = true },
    toml = { "taplo" },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
}

local function has_available_formatter(buffer)
    for _, formatter in ipairs(require("conform").list_formatters(buffer)) do
        if formatter.available then
            return true
        end
    end
    return false
end

local function format(buffer, async)
    if not has_available_formatter(buffer) then
        return
    end

    require("conform").format({
        async = async,
        bufnr = buffer,
        lsp_format = "never",
        quiet = true,
        timeout_ms = 750,
    })
end

return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "ConformInfo",
    keys = {
        {
            "<leader>lf",
            function()
                format(0, true)
            end,
            desc = "LSP: Format buffer",
        },
    },
    opts = {
        formatters_by_ft = formatters_by_filetype,
        format_on_save = function(buffer)
            if has_available_formatter(buffer) then
                return {
                    lsp_format = "never",
                    quiet = true,
                    timeout_ms = 750,
                }
            end
        end,
        notify_no_formatters = false,
    },
}
