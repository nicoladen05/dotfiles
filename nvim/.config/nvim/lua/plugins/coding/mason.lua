return {
    {
        "mason-org/mason.nvim",
        lazy = false,

        opts = {},

        keys = {
            { "<leader>cm", "<cmd>Mason<cr>", desc = "Open Mason" },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig"
        },

        opts = {
            ensure_installed = {
                "lua_ls",
            }
        },
    }
}
