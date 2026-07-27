-- File explorer
local function explorer_paths()
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_directory = current_file ~= "" and vim.fs.dirname(current_file) or vim.fn.getcwd()
    local git_directory = vim.fs.find(".git", {
        path = current_directory,
        upward = true,
    })[1]

    local root = git_directory and vim.fs.dirname(git_directory) or current_directory
    local reveal_file = current_file ~= "" and current_file or nil

    return root, reveal_file
end

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    opts = {
        filesystem = {
            follow_current_file = {
                enabled = true,
            },
            use_libuv_file_watcher = true,
            window = {
                mappings = {
                    ["<CR>"] = "open",
                    ["n"] = function()
                        vim.cmd("normal! j")
                    end,
                    ["e"] = function()
                        vim.cmd("normal! k")
                    end,
                    ["i"] = "open",
                    ["o"] = "close_node",
                },
            },
        },
        window = {
            position = "left",
            width = 30,
        },
    },
    keys = {
        {
            "<leader>n",
            function()
                local root, reveal_file = explorer_paths()

                require("neo-tree.command").execute({
                    source = "filesystem",
                    position = "left",
                    toggle = true,
                    dir = root,
                    reveal_file = reveal_file,
                })
            end,
            desc = "[N]eo-tree",
        },
    },
}
