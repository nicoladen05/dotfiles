-- Install Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize Lazy
local plugins = {
  -- Colorscheme
  { "sainnhe/gruvbox-material", priority = 1000},

  -- Essentials
  { 'nvim-telescope/telescope.nvim', 
    tag = '0.1.6', 
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }
}

local opts = {}

require("lazy").setup(plugins, opts)

-- Colorscheme
vim.cmd.colorscheme "gruvbox-material"
