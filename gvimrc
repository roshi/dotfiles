source ~/.vimrc

" gvim
set lines=55 columns=150
set guioptions-=T
set guioptions-=m
set title
hi CursorLine gui=underline guibg=NONE
map ¥ <leader>

" editexisting
source $VIMRUNTIME/macros/editexisting.vim
