" Exchange a and A for jumping
" to the end of line and do appending.
inoremap aa <ESC>A
nnoremap a A
nnoremap A a

" Split window
nnoremap <silent> ss :sp<CR><C-w>w
nnoremap <silent> sv :vsp<CR><C-w>w

" Move window
nmap <Space> <C-w>w
map s<left> <C-w>h
map s<up> <C-w>k
map s<down> <C-w>j
map s<right> <C-w>l
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l

" Resize window
nmap <C-w><left> <C-w><
nmap <C-w><right> <C-w>>
nmap <C-w><up> <C-w>+
nmap <C-w><down> <C-w>-

" Toggle line number
nnoremap <silent> tn :set invnumber invrelativenumber<CR>

" 'p' to paste, 'gv' to re-select what was originally selected. 'y' to copy it again
xnoremap p pgvy

" NvimTree
nnoremap <F8> :NvimTreeToggle<CR>

" Telescope
nnoremap <F5> :Telescope find_files find_command=rg,-i,--hidden,--files prompt_prefix=🔍 search_dirs=.
nnoremap <F6> :Telescope live_grep prompt_prefix=🔍 search_dirs=.

" Term
if has('win32')
  nnoremap <F12> :tabnew term://pwsh<CR>i
else
  nnoremap <F12> :tabnew term://zsh<CR>i
endif
