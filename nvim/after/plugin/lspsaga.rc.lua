local status, saga = pcall(require, "lspsaga")
if (not status) then return end

function map(mode, lhs, rhs, opts)
  local options = { silent = true }
  if opts then
      options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function nmap(lhs, rhs, opts)
  map("n", lhs, rhs, opts)
end

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
