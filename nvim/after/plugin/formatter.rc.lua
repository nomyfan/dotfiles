local ok,formatter = pcall(require, "formatter")
if (not ok) then return end

formatter.setup {
  filetype = {
    javascript = {
      require('formatter.filetypes.javascript').prettiereslint
    },
    javascriptreact = {
      require('formatter.filetypes.javascriptreact').prettiereslint
    },
    typescript = {
      require('formatter.filetypes.typescript').prettiereslint
    },
    typescriptreact = {
      require('formatter.filetypes.typescriptreact').prettiereslint
    },
    markdown = {
      require('formatter.filetypes.markdown').prettierd
    },
    json = {
      require('formatter.filetypes.json').prettierd
    },
    html = {
      require('formatter.filetypes.html').prettierd
    },
    css = {
      require('formatter.filetypes.css').prettierd
    },
  }
}
