vim.g.mapleader = " "

function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<Space>", "<Nop>")

-- Split window
map("n", "sj", ":set splitbelow<CR>:split<CR>", { silent = true} )
map("n", "sk", ":set nosplitbelow<CR>:split<CR>", { silent = true} )
map("n", "sh", ":set nosplitright<CR>:vsplit<CR>", { silent = true} )
map("n", "sl", ":set splitright<CR>:vsplit<CR>", { silent = true} )

-- Move window
map("n", "<leader><SPACE>", "<C-w>w")
map("n", "<leader><left>", "<C-w>h")
map("n", "<leader><down>", "<C-w>j")
map("n", "<leader><up>", "<C-w>k")
map("n", "<leader><right>", "<C-w>l")
map("n", "<leader>h", "<C-w>h")
map("n", "<leader>j", "<C-w>j")
map("n", "<leader>k", "<C-w>k")
map("n", "<leader>l", "<C-w>l")

-- Resize window
map("n", "<C-w><left>", ":vertical res -10<CR>")
map("n", "<C-w><right>", ":vertical res +10<CR>")
map("n", "<C-w><up>", ":res -10<CR>")
map("n", "<C-w><down>", ":res -10<CR>")
