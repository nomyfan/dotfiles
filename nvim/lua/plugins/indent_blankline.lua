return {
  'lukas-reineke/indent-blankline.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local ibl = require('ibl')
    vim.opt.list = true
    vim.opt.listchars:append 'space:⋅'
    vim.opt.listchars:append 'lead:⋅'
    vim.opt.listchars:append 'trail:⋅'
    -- vim.opt.listchars:append 'eol:↵'
    vim.opt.listchars:append 'tab:⇥⇥'
    -- vim.opt.listchars:append 'nbsp:⋅'

    vim.opt.termguicolors = true
    ibl.setup {}
  end
}
