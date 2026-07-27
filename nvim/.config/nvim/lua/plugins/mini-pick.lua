-- Fuzzy finder
return {
    "nvim-mini/mini.pick",
    version = "0.17.0",
    opts = {},
    keys = {
        {
            "<leader>ff",
            function()
                require("mini.pick").builtin.files()
            end,
            desc = "[F]ind [F]iles",
        },
        {
            "<leader>fg",
            function()
                require("mini.pick").builtin.grep_live()
            end,
            desc = "[F]ind [G]rep",
        },
        {
            "<leader>fb",
            function()
                require("mini.pick").builtin.buffers()
            end,
            desc = "[F]ind [B]uffers",
        },
        {
            "<leader>fh",
            function()
                require("mini.pick").builtin.help()
            end,
            desc = "[F]ind [H]elp",
        },
        {
            "<leader>fr",
            function()
                require("mini.pick").builtin.resume()
            end,
            desc = "[F]ind [R]esume",
        },
    },
}
