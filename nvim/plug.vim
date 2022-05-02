call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'
Plug 'folke/lsp-colors.nvim'
" https://stackoverflow.com/questions/66692772/nvim-treesitter-installation-on-windows
" fix TSUpdate promote 'No C compiler found!'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

Plug 'onsails/lspkind-nvim'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
"Plug 'hrsh7th/vim-vsnip-integ'


Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'kyazdani42/nvim-tree.lua'

Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'

call plug#end()
