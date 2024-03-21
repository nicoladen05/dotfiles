-- Install lazy

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

-- Initiailize
local plugins = {
  "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
  "kyazdani42/nvim-web-devicons",
  --[[ use "xiyaowong/nvim-transparent" -- transparent bq ]]

  -- Automatically close brackets
  "windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter

  -- colorschemes
  "LunarVim/Colorschemes", -- collection of colorschemes
  "sainnhe/gruvbox-material",


  -- filetree
  {
      "nvim-neo-tree/neo-tree.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      }
  },

  -- cmp plugins
  "hrsh7th/nvim-cmp", -- The completion plugin
  "hrsh7th/cmp-buffer", -- buffer completions
  "hrsh7th/cmp-path", -- path completions
  "hrsh7th/cmp-cmdline", -- cmdline completions
  "saadparwaiz1/cmp_luasnip", -- snippet completions
  "hrsh7th/cmp-nvim-lsp",
  "lewis6991/impatient.nvim", -- speeds up the loading of plugins
  "antoinemadec/FixCursorHold.nvim", -- This is needed to fix lsp doc highlight
  "folke/which-key.nvim", -- show popup with keys on leader

  -- snippets
  "L3MON4D3/LuaSnip", --snippet engine
  "rafamadriz/friendly-snippets", -- a bunch of snippets to use

  -- LSP
  "neovim/nvim-lspconfig", -- enable LSP
  "williamboman/nvim-lsp-installer", -- simple to use language server installer
  "tamago324/nlsp-settings.nvim", -- language server settings defined in json for
  "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
  "williamboman/mason.nvim", -- install things
  "williamboman/mason-lspconfig.nvim",
  "kosayoda/nvim-lightbulb", -- show a lightbulb when a codeaction is availible

  -- syntax
  { "nvim-treesitter/nvim-treesitter", build = ':TSUpdate' },

  -- fuzzy finder
  "nvim-telescope/telescope.nvim",

  -- gitsigns
  "lewis6991/gitsigns.nvim",

  -- bufferline
  "akinsho/bufferline.nvim",
  "moll/vim-bbye",

  -- commenting
  "numToStr/Comment.nvim", -- Easily comment stuff
  "JoosepAlviste/nvim-ts-context-commentstring",
  "folke/todo-comments.nvim",

  -- toggle term
  "akinsho/toggleterm.nvim",

  -- dashboard
  "goolord/alpha-nvim",

  -- project management
  "ahmedkhalf/project.nvim",
  -- discord
  --[[ use "andweeb/presence.nvim" ]]

  -- stausline
  "nvim-lualine/lualine.nvim",

  -- zen mode
  "folke/zen-mode.nvim",

  -- ui
  "rcarriga/nvim-notify",

  -- ai
  {
      "Exafunction/codeium.nvim",
      dependencies = {
          "nvim-lua/plenary.nvim",
          "hrsh7th/nvim-cmp",
      },
      config = function()
          require("codeium").setup({
          })
      end
  },

  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },
}
local opts = {}

require("lazy").setup(plugins, opts)

vim.cmd.colorscheme "gruvbox-material"
