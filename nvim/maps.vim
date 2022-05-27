nnoremap <SPACE> <Nop>
let mapleader = " "
set clipboard+=unnamedplus
set splitright
set mouse=a

" Exchange a and A for jumping
" to the end of line and do appending.
inoremap aa <ESC>A
nnoremap a A
nnoremap A a

" Split window
nnoremap <silent> sj :set splitbelow<CR>:split<CR>
nnoremap <silent> sk :set nosplitbelow<CR>:split<CR>
nnoremap <silent> sh :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
nnoremap <silent> sl :set splitright<CR>:vsplit<CR>

" Move window
nnoremap <LEADER><SPACE> <C-w>w
nnoremap <LEADER><left> <C-w>h
nnoremap <LEADER><up> <C-w>k
nnoremap <LEADER><down> <C-w>j
nnoremap <LEADER><right> <C-w>l
nnoremap <LEADER>h <C-w>h
nnoremap <LEADER>k <C-w>k
nnoremap <LEADER>j <C-w>j
nnoremap <LEADER>l <C-w>l

" Resize window
nnoremap <C-w><left> :vertical res -10<CR>
nnoremap <C-w><right> :vertical res +10<CR>
nnoremap <C-w><up> :res +10<CR>
nnoremap <C-w><down> :res -10<CR>

" Toggle line number
nnoremap <silent> tn :set invnumber invrelativenumber<CR>

" 'p' to paste, 'gv' to re-select what was originally selected. 'y' to copy it again
xnoremap p pgvy

" NvimTree begin
nnoremap <silent> <F8> :NvimTreeToggle<CR>
" NvimTree end

" Tagbar begin
"nnoremap <silent> <S-F8> :TagbarToggle<CR>
" Tabbar end

" Telescope begin
nnoremap <F5> :Telescope find_files find_command=rg,-i,--hidden,--files prompt_prefix=🔍 search_dirs=.
nnoremap <F6> :Telescope live_grep prompt_prefix=🔍 search_dirs=.
nnoremap ;f :Telescope find_files find_command=rg,-i,--hidden,--files prompt_prefix=🔍<CR>
nnoremap ;r :Telescope live_grep prompt_prefix=🔍<CR>
"nnoremap <silent> \\ <cmd>Telescope buffers<cr>
"nnoremap <silent> ;; <cmd>Telescope help_tags<cr>
" Telescope end

inoremap <silent> ;; <ESC>
inoremap <silent> ;w <ESC>:w<CR>l
nnoremap <silent> ;w <ESC>:w<CR>
nnoremap <silent> ;s <ESC>:wq<CR>
nnoremap <silent> ;q <ESC>:q<CR>

" LspSaga begin
nnoremap <silent> <leader>ca :Lspsaga code_action<CR>
vnoremap <silent> <leader>ca :<C-U>Lspsaga range_code_action<CR>
nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> <C-k> :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>
nnoremap <silent> <C-h> :Lspsaga signature_help<CR>
nnoremap <silent> <C-f> :lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-b> :lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
nnoremap <silent> gp :Lspsaga preview_definition<CR>
nnoremap <silent> gr :Lspsaga rename<CR>

lua << EOF
local shell = 'pwsh'
if not vim.fn.has('win32') then
  shell = 'zsh'
end
vim.api.nvim_set_keymap('n', '<A-d>', "<cmd>lua require('lspsaga.floaterm').open_float_terminal('"..shell.."')<CR>", { noremap = true, silent = true })
EOF
tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>
" LspSaga end

" Term
if has('win32')
  nnoremap <F12> :tabnew term://pwsh<CR>i
else
  nnoremap <F12> :tabnew term://zsh<CR>i
endif

" https://neovim.io/doc/user/fold.html
" Search for 'OPENING AND CLOSING FOLDS' to see the keymaps
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable

" Reload config(aka init.vim)
nnoremap <silent> <S-R> :so $MYVIMRC<CR>
