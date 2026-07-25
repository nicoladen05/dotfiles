-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local output = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { output, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
    spec = {
        require("plugins.catppuccin"),
        require("plugins.which-key"),
        require("plugins.mini-pick"),
        require("plugins.neo-tree"),
    },
    checker = {
        enabled = true,
    },
    performance = {
        rtp = {
            -- Preserve Ubuntu's multiarch runtime path so Neovim can find its bundled Tree-sitter parsers.
            -- See: https://github.com/folke/lazy.nvim/issues/2177
            reset = false,
        },
    },
})
