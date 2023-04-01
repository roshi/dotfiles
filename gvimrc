set iminsert=0
set imsearch=0

if has('mac')
  set guifont=Menlo:h12
  set linespace=1
  set ambiwidth=double
endif

" gvim
set ambiwidth=double
set lines=55 columns=150
set guioptions-=T
set guioptions-=m
set guioptions-=L
set title
hi CursorLine gui=underline guibg=NONE
map <Char-0xa5> <leader>

" copy path to clipboard
nnoremap <silent> <Leader><Char-0xa5> :let @+ = expand("%:p")<CR>

" editexisting
source $VIMRUNTIME/macros/editexisting.vim
