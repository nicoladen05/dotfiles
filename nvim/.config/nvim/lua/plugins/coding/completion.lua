return {
    "saghen/blink.cmp",

    dependencies = {
        "saghen/blink.lib",
        "rafamadriz/friendly-snippets",
    },

    build = function()
        ---@diagnostic disable-next-line: undefined-field
        require('blink.cmp').build():pwait()
    end,

    opts = {
        keymap = { preset = 'super-tab' },

        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = "mono",
        },

        completion = {
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            }
        }
    },
}
