local null_ls = require('null-ls')
local helpers = require("null-ls.helpers")
local utils = require("null-ls.utils")

local eslint_root_cache = {}
function eslint_root(fullname)
  if eslint_root_cache[fullname] ~= nil then
    return eslint_root_cache[fullname]
  end
  local eslint_root_dir = utils.root_pattern(
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json"
  )(fullname)
  -- '/' is not allowed.
  if eslint_root_dir == '/' then
    eslint_root_dir = nil
  end

  eslint_root_cache[fullname] = eslint_root_dir or false
  return eslint_root_dir
end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with({
      env = {
        PRETTIERD_DEFAULT_CONFIG = vim.fn.expand('~/.config/.prettierrc'),
      },
      filetypes = { 'html', 'markdown', 'json', 'jsonc', 'yaml', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'css', 'scss', 'markdown.mdx' },
    }),
    null_ls.builtins.diagnostics.eslint_d.with({
      runtime_condition = function(params)
        return not not eslint_root(params.bufname)
      end,
      cwd = helpers.cache.by_bufnr(function(params)
        return eslint_root(params.bufname)
      end),
    }),
  }
})
