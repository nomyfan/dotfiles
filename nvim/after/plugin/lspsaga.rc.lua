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
nmap("[e", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
nmap("]e", "<cmd>Lspsaga diagnostic_jump_next<cr>")
nmap("K", "<cmd>Lspsaga hover_doc<cr>")
nmap("gr", "<cmd>Lspsaga rename<cr>")
nmap("gh", "<cmd>Lspsaga lsp_finder<cr>")
nmap("gd", "<cmd>Lspsaga peek_definition<cr>")
map({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", {})
