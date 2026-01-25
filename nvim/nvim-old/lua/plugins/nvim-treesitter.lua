return {
  'nvim-treesitter/nvim-treesitter',
  config = function()
    if require('shared').is_win() then
      require('nvim-treesitter.install').compilers = { 'zig' }
    end

    require('nvim-treesitter').setup {
      highlight = {
        enable = true
      },
      indent = {
        enable = true
      },
      ensure_installed = {
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
      },
      autotag = {
        enable = true
      },
    }

    -- https://www.jmaguire.tech/posts/treesitter_folding/
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldenable = false
  end
}
