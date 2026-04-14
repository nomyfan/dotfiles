require('config.lazy')

if vim.g.vscode then
  -- vscode
else
  require('base')
  require('keymaps')
  vim.opt.background = 'dark'
  vim.cmd.colorscheme 'vellum'
end
