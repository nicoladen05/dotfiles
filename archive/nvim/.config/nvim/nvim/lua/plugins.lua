local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  print('Installing Packer')
  cmd(':!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

cmd [[ packadd packer.nvim ]]

require('packer').startup {
  function()
    use 'wbthomason/packer.nvim'
    
    -- On buffer stuff
    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    }
    use { 
      'norcalli/nvim-colorizer.lua',
      config = function() 
        require('colorizer').setup() 
      end,
    }
    -- use {
    --   'lukas-reineke/indent-blankline.nvim',
    --   config = function()
    --     require('plugins.indent_blankline')
    --   end,
    -- }
    use {
      'nvim-treesitter/nvim-treesitter',
      requires = { 'nathom/filetype.nvim' },
      config = function()
        require('plugins.treesitter')
      end
    }
    
    -- UI
    use 'RRethy/nvim-base16'
    use {
      'kyazdani42/nvim-tree.lua',
      config = function() 
        require('plugins.nvim-tree')
      end,
    }
    use { 
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function() 
        require('plugins.gitsigns')
      end,
    }
    use { 
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function() 
        require('plugins.telescope')
      end,
    }
    use {
      'akinsho/bufferline.nvim',
      config = function()
        require('plugins.bufferline')
      end,
    }
    use {"akinsho/toggleterm.nvim", tag = 'v1.*',
    config = function()
      require('plugins.toggleterm')
    end,
    }
     
    -- Completion
    use {
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup()
      end
    }
    use {
      'hrsh7th/nvim-cmp',
      requires = { 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline', 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-nvim-lsp'},
      config = function()
        require('plugins.cmp')
      end,
    }
    use {
      "zbirenbaum/copilot.lua",
      event = {"VimEnter"},
      config = function()
        vim.defer_fn(function()
          require("copilot").setup()
        end, 100)
      end,
    }

    -- Lsp
    use {
      'neovim/nvim-lspconfig',
      requires = {'williamboman/nvim-lsp-installer', 'tamago324/nlsp-settings.nvim', 'jose-elias-alvarez/null-ls.nvim'},
      config = function()
        require('plugins.lsp')
      end,
    }


    
    -- Snippets
    use {
      'L3MON4D3/LuaSnip',
      after = 'nvim-cmp',
      requires = { 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' },
      config = function()
        require('plugins.luasnip')
      end,
    }
  end,

  config = {
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'single' }
      end,
      prompt_border = 'single',
    },
  },
}
