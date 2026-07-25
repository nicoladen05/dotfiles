return {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
        progress = {
            display = {
                done_ttl = 2,
            },
        },
        notification = {
            window = {
                winblend = 0,
            },
        },
    },
}
