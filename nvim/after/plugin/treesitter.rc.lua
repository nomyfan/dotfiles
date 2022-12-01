require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  ensure_installed = {
    "tsx",
    "css",
    "html",
    "lua"
  },
  autotag = {
    enable = true
  }
})
