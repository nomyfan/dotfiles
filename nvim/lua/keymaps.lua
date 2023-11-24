local shared = require('shared')
local nmap = shared.nmap
local map = shared.map

vim.g.mapleader = " "

nmap("<Space>", "<Nop>", { noremap = false })

-- Split window
nmap("sj", ":set splitbelow<CR>:split<CR>", { silent = true} )
nmap("sk", ":set nosplitbelow<CR>:split<CR>", { silent = true} )
nmap("sh", ":set nosplitright<CR>:vsplit<CR>", { silent = true} )
nmap("sl", ":set splitright<CR>:vsplit<CR>", { silent = true} )

-- Move window
nmap("<Leader><Tab>", "<C-w>w")
--nmap("<Leader><Left>", "<C-w>h")
--nmap("<Leader><Down>", "<C-w>j")
--nmap("<Leader><Up>", "<C-w>k")
--nmap("<Leader><Right>", "<C-w>l")
nmap("<Leader>wh", "<C-w>h")
nmap("<Leader>wj", "<C-w>j")
nmap("<Leader>wk", "<C-w>k")
nmap("<Leader>wl", "<C-w>l")

-- Resize window
nmap("<Leader><Left>", ":vertical res -10<CR>")
nmap("<Leader><Right>", ":vertical res +10<CR>")
nmap("<Leader><Up>", ":res +10<CR>")
nmap("<Leader><Down>", ":res -10<CR>")

-- Nvim tree keymaps
nmap('<Leader>tt', ':NvimTreeToggle<CR>')
nmap('<Leader>tf', ':NvimTreeFindFile<CR>')

-- Reload config(aka init.lua)
nmap('<S-R>', ':so $MYVIMRC<CR>')

-- Telescope
nmap("<Leader>fD", require('nvim-tree-telescope').launch_find_files)
nmap("<Leader>fd", function(opts)
  opts = opts or {}
  opts.basedir = '.'
  return require('nvim-tree-telescope').launch_find_files(opts)
end)
nmap('<Leader>G', require('nvim-tree-telescope').launch_live_grep)
nmap('<Leader>g', function(opts)
  opts = opts or {}
  opts.basedir = '.' 
  return require('nvim-tree-telescope').launch_live_grep(opts)
end)

-- LspSaga
nmap("[e", "<Cmd>Lspsaga diagnostic_jump_prev<CR>")
nmap("]e", "<Cmd>Lspsaga diagnostic_jump_next<CR>")
nmap("[E", function()
  require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
nmap("]E", function()
  require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end)
nmap("K", "<Cmd>Lspsaga hover_doc<CR>")
nmap("rn", "<Cmd>Lspsaga rename<CR>")
nmap("fi", "<Cmd>Lspsaga finder<CR>")
nmap("gd", "<Cmd>Lspsaga goto_definition<CR>")
nmap("gp", "<Cmd>Lspsaga peek_definition<CR>")
map({ "n", "v" }, "<Leader>ca", "<Cmd>Lspsaga code_action<CR>", {})

nmap("<Leader>F", ":lua vim.lsp.buf.format()<CR>", { silent = true })

-- Format on save
vim.api.nvim_create_user_command("W", function()
  vim.cmd("lua vim.lsp.buf.format()")
  vim.cmd("w")
end ,{})

map({ "t" }, "<Esc>", "<C-\\><C-n>", { silent = true })

-- Switch buffer
map("n", "<Tab>", ":bnext<CR>", { silent = true })
map("n", "<S-Tab>", ":bprev<CR>", { silent = true })

