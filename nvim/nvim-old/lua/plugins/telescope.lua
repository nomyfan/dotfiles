return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local actions = require('telescope.actions')
    local shared = require('shared')
    local nmap = shared.nmap

    require('telescope').setup {
      defaults = {
        mappings = {
          n = {
            ['q'] = actions.close
          }
        }
      }
    }

    shared.with_module('nvim-tree', function()
      nmap('<Leader>fF', require('nvim-tree-telescope').launch_find_files)
      nmap('<Leader>ff', function(opts)
        opts = opts or {}
        opts.basedir = '.'
        return require('nvim-tree-telescope').launch_find_files(opts)
      end)
      nmap('<Leader>fG', require('nvim-tree-telescope').launch_live_grep)
      nmap('<Leader>fg', function(opts)
        opts = opts or {}
        opts.basedir = '.' 
        return require('nvim-tree-telescope').launch_live_grep(opts)
      end)
    end)
    local builtin = require('telescope.builtin')
    nmap('<leader>fb', builtin.buffers)
    nmap('<leader>fr', builtin.resume)
  end
}
