return {
  'lukas-reineke/indent-blankline.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    vim.opt.list = true
    vim.opt.listchars = {
      -- space = '·',
      lead = '·',
      trail = '·',
      tab = '→ ',
      -- eol = '↵',
      nbsp = '␣',
    }

    vim.opt.termguicolors = true
    require('ibl').setup()
  end
}
