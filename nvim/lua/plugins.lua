local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use "wbthomason/packer.nvim"
  use {
    'svrana/neosolarized.nvim',
    requires = { 'tjdevries/colorbuddy.nvim' }
  }
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'

  use 'norcalli/nvim-colorizer.lua'

  use 'neovim/nvim-lspconfig' -- LSP

  use 'onsails/lspkind-nvim'

  -- cmp
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/nvim-cmp'

  use 'akinsho/nvim-bufferline.lua'
end)
