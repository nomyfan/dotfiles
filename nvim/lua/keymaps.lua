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

-- Close all buffers but current one
vim.api.nvim_create_user_command('Bd', function()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, i in ipairs(bufs) do
    if i ~= current_buf then
        vim.api.nvim_buf_delete(i, {})
    end
  end
end, {})

-- Switch buffer
map('n', '<Tab>', ':bnext<CR>', { silent = true })
map('n', '<S-Tab>', ':bprev<CR>', { silent = true })

