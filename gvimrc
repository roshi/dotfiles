source ~/.vimrc

" gvim
set lines=60 columns=140
set guioptions+=T
set title
hi CursorLine gui=underline guibg=NONE
map ¥ <leader>

" menu
source $VIMRUNTIME/delmenu.vim
set langmenu=ja_jp.utf-8
source $VIMRUNTIME/menu.vim
