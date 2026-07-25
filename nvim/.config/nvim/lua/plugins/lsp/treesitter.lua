local ensure_installed = {
    "css",
    "html",
    "javascript",
    "json",
    "markdown",
    "markdown_inline",
    "svelte",
    "toml",
    "typescript",
    "yaml",
}

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {},
    config = function(_, opts)
        local treesitter = require("nvim-treesitter")
        treesitter.setup(opts)
        treesitter.install(ensure_installed)

        local highlight_group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = highlight_group,
            callback = function(args)
                local language = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                if not language then
                    return
                end

                local parser_available = pcall(vim.treesitter.language.add, language)
                if parser_available then
                    pcall(vim.treesitter.start, args.buf, language)
                end
            end,
        })
    end,
}
