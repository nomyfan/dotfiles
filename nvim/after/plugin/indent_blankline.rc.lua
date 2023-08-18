local ok, ib = pcall(require, "indent_blankline")
if not ok then return end

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "lead:⋅"
vim.opt.listchars:append "trail:⋅"
vim.opt.listchars:append "eol:↵"
vim.opt.listchars:append "tab:⇥⇥"
-- vim.opt.listchars:append "nbsp:⋅"

vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#454545 gui=nocombine]]

ib.setup {
  show_end_of_line = true,
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
  use_treesitter = true,
  char_highlight_list = {
    "IndentBlanklineIndent1",
  },
  space_char_highlight_list = {
    "IndentBlanklineIndent1",
  },
}
