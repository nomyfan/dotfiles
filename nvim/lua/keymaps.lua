vim.g.mapleader = " "

function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function nmap(lhs, rhs, opts)
  map('n', lhs, rhs, opts)
end

nmap("<Space>", "<Nop>", { noremap = false })

-- Split window
nmap("sj", ":set splitbelow<CR>:split<CR>", { silent = true} )
nmap("sk", ":set nosplitbelow<CR>:split<CR>", { silent = true} )
nmap("sh", ":set nosplitright<CR>:vsplit<CR>", { silent = true} )
nmap("sl", ":set splitright<CR>:vsplit<CR>", { silent = true} )

-- Move window
nmap("<Leader><SPACE>", "<C-w>w")
--nmap("<Leader><Left>", "<C-w>h")
--nmap("<Leader><Down>", "<C-w>j")
--nmap("<Leader><Up>", "<C-w>k")
--nmap("<Leader><Right>", "<C-w>l")
nmap("<Leader>h", "<C-w>h")
nmap("<Leader>j", "<C-w>j")
nmap("<Leader>k", "<C-w>k")
nmap("<Leader>l", "<C-w>l")

-- Resize window
nmap("<Leader><Left>", ":vertical res -10<CR>")
nmap("<Leader><Right>", ":vertical res +10<CR>")
nmap("<Leader><Up>", ":res -10<CR>")
nmap("<Leader><Down>", ":res -10<CR>")

-- Nvim tree keymaps
nmap('<Leader>tt', ':NvimTreeToggle<CR>')
nmap('<Leader>tf', ':NvimTreeFindFile<CR>')

-- Reload config(aka init.lua)
nmap('<S-R>', ':so $MYVIMRC<CR>')
