if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc.vim', {
\   'build': {
\     'windows': 'tools\\update-dll-mingw', 
\     'cygwin': 'make -f make_cygwin.mak', 
\     'mac': 'make -f make_mac.mak', 
\     'unix': 'make -f make_unix.mak', 
\   }, 
\ }
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'rking/ag.vim'

call neobundle#end()

filetype plugin indent on
NeoBundleCheck


" file
set autoread
set hidden
set noswapfile
set nobackup
syntax on

" input
set backspace=indent,eol,start
set formatoptions=lmoq
set clipboard=unnamed,autoselect
set virtualedit=block

" indent
set tabstop=4 shiftwidth=4 softtabstop=0
set autoindent
set smartindent
set nocindent

" search
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch

" view
set showmatch
set showcmd
set showmode
set number
set nowrap
set list
set listchars=tab:>\ 
set title
set scrolloff=5
set display=uhex
set foldlevel=99
set cursorline
set splitbelow

" status
set laststatus=2
set statusline=%f%m%=[0x%B]%y[%{&fileencoding}][%{&fileformat}]

" backup
set directory=~/.vim/tmp
set backupdir=~/.vim/tmp
set undodir=~/.vim/tmp

" encoding
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932

" quickrun
let g:quickrun_config = {}
let g:quickrun_config._ = {'split': 'below'}

" ag
let g:agprg="/usr/local/bin/ag -i --column"

" unite
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_rec_async_command = 'ag --nogroup --nocolor --column --follow --hidden -g ""'
endif

" call unite#custom#source('file_rec/async', 'ignore_pattern', '(png\|gif\|jpeg\|jpg)$')

nnoremap [unite] <Nop>
nmap <Space> [unite]

nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file file/new<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]r :<C-u>Unite file_rec/async:!<CR>
nnoremap <silent> [unite]g :<C-u>Unite file_rec/git:!<CR>

au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" golang
if $GOROOT != ''
  set runtimepath+=$GOROOT/misc/vim
endif
