return {
  'glepnir/lspsaga.nvim',
  config = function()
    local shared = require('shared')
    local nmap = shared.nmap
    local map = shared.map

    require('lspsaga').setup {
      ui = {
        devicon = true,
        code_action = '🚧',
      },
      lightbulb = {
        -- Showing in the status column will cause flickering.
        sign = false,
      }
    }

    nmap('[e', '<Cmd>Lspsaga diagnostic_jump_prev<CR>')
    nmap(']e', '<Cmd>Lspsaga diagnostic_jump_next<CR>')
    nmap('[E', function()
      require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end)
    nmap(']E', function()
      require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })
    end)
    nmap('K', '<Cmd>Lspsaga hover_doc<CR>')
    nmap('rn', '<Cmd>Lspsaga rename<CR>')
    nmap('fi', '<Cmd>Lspsaga finder<CR>')
    nmap('gd', '<Cmd>Lspsaga goto_definition<CR>')
    nmap('gp', '<Cmd>Lspsaga peek_definition<CR>')
    map({ 'n', 'v' }, '<Leader>ca', '<Cmd>Lspsaga code_action<CR>', {})
  end
}
