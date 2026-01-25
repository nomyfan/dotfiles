return {
  {
    'nvim-mini/mini.nvim',
    tag = 'v0.17.0',
    config = function()
      -- require('mini.comment').setup()
      require('mini.basics').setup()
      require('mini.starter').setup()
      require('mini.sessions').setup()
    end
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup()
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local shared = require('shared')
      local nmap = shared.nmap
      nmap('<Leader>tt', ':Neotree toggle<CR>', { desc = 'Toggle NeoTree', silent = true })
      nmap('<Leader>tf', ':Neotree reveal<CR>', { desc = 'Toggle NeoTree', silent = true })
      require('neo-tree').setup({
        auto_clean_after_session_restore = true
      })
    end
  },
  {
    'savq/melange-nvim',
    config = function()
      vim.opt.background = 'dark'
      vim.cmd.colorscheme 'melange'
    end
  },
  { 'wakatime/vim-wakatime' },
  { 'github/copilot.vim' },
  {
    'windwp/nvim-autopairs',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      disable_filetype = { 'TelescopePrompt', 'vim' },
      check_ts = true,
    }
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' }
  },
  {
    "mason-org/mason.nvim",
    opts = {}
  },
  {
    'rachartier/tiny-code-action.nvim',
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    event = "LspAttach",
    opts = {},
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    config = function()
      require('markview').setup({
        preview = {
          enable = false
        }
      })
    end
  }
}
