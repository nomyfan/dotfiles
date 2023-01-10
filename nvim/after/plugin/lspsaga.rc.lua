local status, saga = pcall(require, "lspsaga")
if (not status) then return end

local shared = require('shared')
local map = shared.map
local nmap = shared.nmap

saga.init_lsp_saga()
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
nmap("gd", "<Cmd>Lspsaga peek_definition<CR>")
map({ "n", "v" }, "<Leader>ca", "<Cmd>Lspsaga code_action<CR>", {})
