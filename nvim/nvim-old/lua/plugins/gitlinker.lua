return {
  'nomyfan/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local gitlinker = require('gitlinker')
    local shared = require('shared')
    local map = shared.map

    gitlinker.setup {
      opts = {
        print_url = false,
      },
      mappings = ''
    }

    map('n', '<leader>;', function()
      gitlinker.get_buf_range_url('n', { action_callback = gitlinker.actions.open_in_browser })
    end, { silent = true })

    map('v', '<leader>;', function()
      gitlinker.get_buf_range_url('v', { action_callback = gitlinker.actions.open_in_browser })
    end, { silent = true })

  end
}

