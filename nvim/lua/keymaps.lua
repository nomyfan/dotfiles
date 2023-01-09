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
nmap("<leader><SPACE>", "<C-w>w")
--nmap("<leader><left>", "<C-w>h")
--nmap("<leader><down>", "<C-w>j")
--nmap("<leader><up>", "<C-w>k")
--nmap("<leader><right>", "<C-w>l")
nmap("<leader>h", "<C-w>h")
nmap("<leader>j", "<C-w>j")
nmap("<leader>k", "<C-w>k")
nmap("<leader>l", "<C-w>l")

-- Resize window
nmap("<leader><left>", ":vertical res -10<CR>")
nmap("<leader><right>", ":vertical res +10<CR>")
nmap("<leader><up>", ":res -10<CR>")
nmap("<leader><down>", ":res -10<CR>")

-- Nvim tree keymaps
nmap('<leader>tt', ':NvimTreeToggle<CR>')
nmap('<leader>tf', ':NvimTreeFindFile<CR>')
