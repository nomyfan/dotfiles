function setup_midnight()
  require('midnight').setup {}
  vim.cmd.colorscheme 'midnight'
end

function setup_material()
  require("material").setup {
    contrast = {
      cursor_line = true,
    }
  }

  vim.g.material_style = 'oceanic'
  vim.g.material_style = 'darker'
  vim.g.material_style = 'deep ocean'
  vim.cmd.colorscheme 'material'
end

function setup_solarized_dark()
  require('solarized-osaka').setup {}
  vim.cmd.colorscheme 'solarized-osaka'
end

-- setup_midnight()
-- setup_material()
setup_solarized_dark()
