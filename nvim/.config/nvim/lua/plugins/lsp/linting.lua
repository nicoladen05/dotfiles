local linters_by_filetype = {
    bash = {
        { name = "shellcheck", executable = "shellcheck" },
    },
    css = {
        { name = "stylelint", executable = "stylelint" },
    },
    javascript = {
        { name = "eslint_d", executable = "eslint_d", first = true },
        { name = "eslint", executable = "eslint", first = true },
    },
    javascriptreact = {
        { name = "eslint_d", executable = "eslint_d", first = true },
        { name = "eslint", executable = "eslint", first = true },
    },
    json = {
        { name = "jsonlint", executable = "jsonlint" },
    },
    markdown = {
        { name = "markdownlint", executable = "markdownlint" },
    },
    sh = {
        { name = "shellcheck", executable = "shellcheck" },
    },
    typescript = {
        { name = "eslint_d", executable = "eslint_d", first = true },
        { name = "eslint", executable = "eslint", first = true },
    },
    typescriptreact = {
        { name = "eslint_d", executable = "eslint_d", first = true },
        { name = "eslint", executable = "eslint", first = true },
    },
    yaml = {
        { name = "yamllint", executable = "yamllint" },
    },
}

local function available_linters(filetype)
    local available = {}
    for _, linter in ipairs(linters_by_filetype[filetype] or {}) do
        if vim.fn.executable(linter.executable) == 1 then
            table.insert(available, linter.name)
            if linter.first then
                break
            end
        end
    end
    return available
end

local function lint_buffer()
    local linters = available_linters(vim.bo.filetype)
    if #linters > 0 then
        require("lint").try_lint(linters, { ignore_errors = true })
    end
end

return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local lint_group = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
            group = lint_group,
            callback = lint_buffer,
        })
    end,
}
