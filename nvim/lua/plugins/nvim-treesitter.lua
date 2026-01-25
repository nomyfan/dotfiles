local langs = {
  'tsx',
  'typescript',
  'javascript',
  'vue',
  'css',
  'scss',
  'html',
  'yaml',
  'toml',
  'lua',
  'markdown',
  'markdown_inline',
  'json',
  'json5',
 'go',
  'rust',
  'java',
  'dockerfile',
  'c',
  'c_sharp',
  'dart',
  'python',
  'gitignore',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'cmake',
  'latex',
  'typst',
  'comment',
}

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  config = function()
    local ts = require('nvim-treesitter')

    ts.setup()
    -- Ensure install
    ts.install(langs)

    -- Highlight
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local ok = pcall(vim.treesitter.language.get_lang, ft)
        if not ok then return end

        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then return end
        if not pcall(vim.treesitter.language.add, lang) then
          return
        end

        pcall(vim.treesitter.start, ev.buf, lang)
      end,
    })

    -- Indentation
    vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    -- Folding
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldenable = false
  end
}
