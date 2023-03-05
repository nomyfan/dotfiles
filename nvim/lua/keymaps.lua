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
nmap("<Leader><Up>", ":res +10<CR>")
nmap("<Leader><Down>", ":res -10<CR>")

-- Nvim tree keymaps
nmap('<Leader>tt', ':NvimTreeToggle<CR>')
nmap('<Leader>tf', ':NvimTreeFindFile<CR>')

-- Reload config(aka init.lua)
nmap('<S-R>', ':so $MYVIMRC<CR>')

-- Telescope
nmap('<Leader>ff', ':Telescope fd find_command=rg,-i,--hidden,--files search_dir=.<CR>')
nmap('<Leader>fg', ':Telescope live_grep search_dir=.<CR>')
nmap('<Leader>ll', function()
  require('nvim-tree-telescope').launch_find_files({
    --find_command = { 'rg', '-i', '--hidden', '--files' }
  })
end)
nmap('<Leader>lg', function()
  require('nvim-tree-telescope').launch_live_grep()
end)

-- LspSaga
nmap("[e", "<Cmd>Lspsaga diagnostic_jump_prev<CR>")
nmap("]e", "<Cmd>Lspsaga diagnostic_jump_next<CR>")
nmap("[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
nmap("]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end)
nmap("K", "<Cmd>Lspsaga hover_doc<CR>")
nmap("gr", "<Cmd>Lspsaga rename<CR>")
nmap("gh", "<Cmd>Lspsaga lsp_finder<CR>")
nmap("gd", "<Cmd>Lspsaga goto_definition<CR>")
nmap("gp", "<Cmd>Lspsaga peek_definition<CR>")
map({ "n", "v" }, "<Leader>ca", "<Cmd>Lspsaga code_action<CR>", {})

nmap("<Leader>f", ":Format<CR>", { silent = true })
