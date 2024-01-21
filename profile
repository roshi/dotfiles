# load once only at login

export GOPATH=~/.cache/go
export INPUTRC=~/.config/readline/inputrc
export VIMINIT='let $MYVIMRC = has("nvim") ? "$HOME/.config/nvim/init.lua" : "$HOME/.config/vim/vimrc" | source $MYVIMRC'
export GVIMINIT='let $MYVIMRC = has("nvim") ? "$HOME/.config/nvim/ginit.lua" : "$HOME/.config/vim/gvimrc" | source $MYVIMRC'

#vim: set ft=sh
