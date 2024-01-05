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

-- Save current session and exit nvim.
vim.api.nvim_create_user_command("X", function()
  local i = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_get_option_value("modified", { buf = buf }) then
        return
      end
  end
  require('session_manager').save_current_session()
  vim.cmd("qa")
end, {})

-- Load session for current directory.
vim.api.nvim_create_user_command("L", function()
  require('session_manager').load_current_dir_session()
end, {})

function string.starts_with(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = function(data)
  local is_directory = vim.fn.isdirectory(data.file) == 1
  if is_directory then
    vim.cmd.cd(data.file)
  end

  local argc = vim.fn.argc()
  if argc == 1 and is_directory then
    -- Partially copy from session_manager.load_current_dir_session
    local cwd = vim.fn.getcwd()
    if cwd then
      local session = require('session_manager.config').dir_to_session_filename(cwd)
      if session:exists() then
        require('session_manager').load_current_dir_session()
        return
      end
    end

    -- Fallback
    require("nvim-tree.api").tree.open()
  end
end})
