if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'thinca/vim-quickrun'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

set tabstop=4

set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932

set number
set nowrap

set autoindent
set nosmartindent
set nocindent

set laststatus=2
set statusline=%f%m%=[0x%B]%y[%{&fileencoding}][%{&fileformat}]

set hlsearch
set ignorecase
set incsearch

set list
set listchars=tab:>\ 

set autoread
set noswapfile
set undodir=~/.vim/tmp

let g:quickrun_config={'*': {'split': ''}}
set splitbelow

let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap [unite] <Nop>
nmap <Space> [unite]

nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file file/new<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>

au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

if $GOROOT != ''
  set runtimepath+=$GOROOT/misc/vim
endif
