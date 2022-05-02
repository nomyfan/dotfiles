syntax enable
set nocompatible
set hlsearch
set number
set relativenumber
set expandtab
set tabstop=2
set shiftwidth=2
set ignorecase
set smartcase
"set nowrap
set ai "Auto indent
set si "Smart indent
"set backupskip=/tmp/*,/private/tmp/*

runtime ./plug.vim

set cursorline
"set cursorcolumn

" File types
" JavaScript
au BufNewFile,BufRead *.es6 set filetype=javascript
" TypeScript
au BufNewFile,BufRead *.tsx set filetype=typescriptreact
"au BufNewFile,BufRead *.jsx set filetype=typescriptreact
" Markdown
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.mdx set filetype=markdown
" Flow
au BufNewFile,BufRead *.flow set filetype=javascript

set suffixesadd=.js,.es,.jsx,.tsx.json,.css,.less,.sass,.styl,.php,.py,.md


" true color
if exists("&termguicolors") && exists("&winblend")
  syntax enable
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
  set background=dark
  " Use NeoSolarized
  let g:neosolarized_termtrans=1
  runtime ./colors/NeoSolarized.vim
  colorscheme NeoSolarized
endif

runtime ./maps.vim


