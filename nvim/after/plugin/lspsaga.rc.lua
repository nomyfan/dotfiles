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
nmap("[e", "<CMD>Lspsaga diagnostic_jump_prev<CR>")
nmap("]e", "<CMD>Lspsaga diagnostic_jump_next<CR>")
nmap("[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
nmap("]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end)
nmap("K", "<CMD>Lspsaga hover_doc<CR>")
nmap("gr", "<CMD>Lspsaga rename<CR>")
nmap("gh", "<CMD>Lspsaga lsp_finder<CR>")
nmap("gd", "<CMD>Lspsaga peek_definition<CR>")
map({ "n", "v" }, "<LEADER>ca", "<CMD>Lspsaga code_action<CR>", {})
