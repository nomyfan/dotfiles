local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with({
      env = {
        PRETTIERD_DEFAULT_CONFIG = vim.fn.expand('~/.config/.prettierrc'),
      },
      filetypes = { 'html', 'markdown', 'json', 'jsonc', 'yaml', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'css', 'scss', 'markdown.mdx' },
    }),
    null_ls.builtins.diagnostics.eslint_d,
  }
})
