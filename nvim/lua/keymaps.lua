local shared = require('shared')
local nmap = shared.nmap
local map = shared.map

vim.g.mapleader = ' '

nmap('<Space>', '<Nop>', { noremap = false })

-- Split window
nmap('sj', ':set splitbelow<CR>:split<CR>', { silent = true} )
nmap('sk', ':set nosplitbelow<CR>:split<CR>', { silent = true} )
nmap('sh', ':set nosplitright<CR>:vsplit<CR>', { silent = true} )
nmap('sl', ':set splitright<CR>:vsplit<CR>', { silent = true} )

-- Move window
nmap('<Leader><Tab>', '<C-w>w')
--nmap('<Leader><Left>', '<C-w>h')
--nmap('<Leader><Down>', '<C-w>j')
--nmap('<Leader><Up>', '<C-w>k')
--nmap('<Leader><Right>', '<C-w>l')
nmap('<Leader>wh', '<C-w>h')
nmap('<Leader>wj', '<C-w>j')
nmap('<Leader>wk', '<C-w>k')
nmap('<Leader>wl', '<C-w>l')

-- Resize window
nmap('<Leader><Left>', ':vertical res -10<CR>')
nmap('<Leader><Right>', ':vertical res +10<CR>')
nmap('<Leader><Up>', ':res +10<CR>')
nmap('<Leader><Down>', ':res -10<CR>')

-- Buffer navigation
nmap('<Tab>', ':bnext<CR>', { silent = true })
nmap('<S-Tab>', ':bprev<CR>', { silent = true })

-- Sessions
local function session_name_path_hash()
  local cwd = vim.fn.getcwd()
  local base = vim.fn.fnamemodify(cwd, ':t')
  local hash = vim.fn.sha256(cwd):sub(1, 8)
  return string.format('%s-%s', base, hash)
end

nmap('<Leader>sw', function()
  local session_name = session_name_path_hash()
  require('mini.sessions').write(session_name)
end)

nmap('<Leader>sr', function()
  local session_name = session_name_path_hash()
  require('mini.sessions').read(session_name)
end)

-- System clipboard
map({'n', 'v'}, '<leader>y', '"+y')
map({'n', 'v'}, '<leader>d', '"+d')
map({'n', 'v'}, '<leader>p', '"+p')

--- Yank the current visual selection as a file line range reference (e.g. src/foo.lua#L10-20).
--- @param opts? { absolute?: boolean, register?: string }
local function yank_line_range(opts)
  opts = opts or {}
  local absolute = opts.absolute or false
  local register = opts.register or '+'

  local start_line = vim.fn.line('v')
  local end_line   = vim.fn.line('.')
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local filename = absolute and vim.fn.expand('%:p') or vim.fn.fnamemodify(vim.fn.expand('%:p'), ':.')

  local line_range = filename .. '#L' .. start_line
  if start_line ~= end_line then
    line_range = line_range .. '-' .. end_line
  end

  vim.fn.setreg(register, line_range)
  vim.notify('Yanked: ' .. line_range)
end

-- Default: relative path
vim.keymap.set('v', '<leader>yl', function() yank_line_range() end,
  { desc = 'Yank file#Lrange (relative)' })

-- Absolute path variant
vim.keymap.set('v', '<leader>yL', function() yank_line_range({ absolute = true }) end,
  { desc = 'Yank file#Lrange (absolute)' })
