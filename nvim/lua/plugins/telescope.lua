return {
  'nvim-telescope/telescope.nvim', tag = '0.2.1',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local shared = require('shared')
    local nmap = shared.nmap

    require('telescope').setup({})
    local builtin = require('telescope.builtin')
    nmap('<leader>ff', builtin.find_files)
    nmap('<leader>fg', builtin.live_grep)
    nmap('<leader>fb', builtin.buffers)
    nmap('<leader>fr', builtin.resume)
    nmap('<leader>fd', builtin.diagnostics)
  end
}
