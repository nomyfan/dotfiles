return {
  { 'nvim-tree/nvim-web-devicons',
    opts = {
      default = true
    }
  },
  { 'craftzdog/solarized-osaka.nvim',
    config = function()
      require('solarized-osaka').setup {}
      vim.cmd.colorscheme 'solarized-osaka'
      local colors = require('solarized-osaka.colors')
      vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = colors.default.fg, bg = colors.default.bg_highlight })
    end
  },
  { 'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  },
  { 'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  { 'wakatime/vim-wakatime' },
  { 'github/copilot.vim' },
  { 'windwp/nvim-autopairs',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      disable_filetype = { 'TelescopePrompt' , 'vim' },
      check_ts = true,
    }
  },
  { 'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    init = function()
    end
  },
  { 'folke/zen-mode.nvim' },
  { 'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end
  }
}
