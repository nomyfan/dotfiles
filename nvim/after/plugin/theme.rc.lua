local loaded, _ = pcall(require, 'material')
if (not loaded) then return end

vim.cmd 'colorscheme material'
vim.g.material_style = 'oceanic'
