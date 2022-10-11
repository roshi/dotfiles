set iminsert=0
set imsearch=0

if has('mac')
  set guifont=Menlo:h12
  set linespace=1
  set ambiwidth=double
endif

" gvim
set lines=55 columns=150
set guioptions-=T
set guioptions-=m
set guioptions-=L
set title
hi CursorLine gui=underline guibg=NONE
map ¥ <leader>

" editexisting
source $VIMRUNTIME/macros/editexisting.vim
