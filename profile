# load once only at login

export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state

export GOPATH=${XDG_DATA_HOME}/go
export INPUTRC=${XDG_CONFIG_HOME}/readline/inputrc
export LESSHISTFILE=-
export VIMINIT='let $MYVIMRC = has("nvim") ? "$XDG_CONFIG_HOME/nvim/init.lua" : "$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export GVIMINIT='let $MYVIMRC = has("nvim") ? "$XDG_CONFIG_HOME/nvim/ginit.lua" : "$XDG_CONFIG_HOME/vim/gvimrc" | source $MYVIMRC'

#vim: set ft=sh
