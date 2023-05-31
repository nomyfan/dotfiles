local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

--vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use "wbthomason/packer.nvim"
  --use {
  --  'svrana/neosolarized.nvim',
  --  requires = { 'tjdevries/colorbuddy.nvim' }
  --}
  use 'marko-cerovac/material.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'

  use 'norcalli/nvim-colorizer.lua'
  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'glepnir/lspsaga.nvim'
  use 'onsails/lspkind-nvim'
  use 'simrat39/rust-tools.nvim'

  -- cmp
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/nvim-cmp'
  -- code snippets
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-vsnip'

  use 'akinsho/nvim-bufferline.lua'

  use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
      end,
  }
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use 'lewis6991/gitsigns.nvim'
  use 'nvim-tree/nvim-tree.lua'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'wakatime/vim-wakatime'
  use 'mhartington/formatter.nvim'
  use 'github/copilot.vim'
end)
