return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  lazy = false,
  config = function()
    local shared = require('shared')
    local nmap = shared.nmap

    require('nvim-tree').setup {
      view = {
        width = function()
          return 40
        end,
      },
      hijack_directories = {
        enable = false,
        auto_open = false,
      }
    }
    nmap('<Leader>tt', ':NvimTreeToggle<CR>')
    nmap('<Leader>tf', ':NvimTreeFindFile<CR>')
  end
}
