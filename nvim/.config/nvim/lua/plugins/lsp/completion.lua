-- IDE-style completion backed by the native Neovim snippet API.
return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    opts = {
        keymap = {
            preset = "default",
            ["<CR>"] = { "accept", "fallback" },
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
            },
            ghost_text = {
                enabled = true,
            },
        },
        signature = {
            enabled = true,
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
    },
    opts_extend = { "sources.default" },
}
