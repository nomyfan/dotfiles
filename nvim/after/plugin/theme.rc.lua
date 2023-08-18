local ok, material = pcall(require, 'material')
if not ok then return end

material.setup {
  contrast = {
    cursor_line = true,
  }
}
-- vim.g.material_style = 'oceanic'
vim.g.material_style = 'darker'
vim.cmd 'colorscheme material'
