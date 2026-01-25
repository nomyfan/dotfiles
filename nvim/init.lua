require('config.lazy')

if vim.g.vscode then
  -- vscode
else
  require('base')
  require('keymaps')
end
