require("nvim-treesitter.install").compilers = { "zig" }
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  ensure_installed = {
    "tsx",
    "typescript",
    "javascript",
    "vue",
    "css",
    "scss",
    "html",
    "yaml",
    "toml",
    "lua",
    "markdown",
    "json",
    "json5",
    "go",
    "rust",
    "java",
    "dockerfile",
    "c",
    "c_sharp",
    "dart",
    "python",
    "gitignore",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "cmake",
  },
  autotag = {
    enable = true
  }
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
