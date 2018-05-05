if &compatible
  set nocompatible
endif

let s:dein_dir=expand('~/.cache/dein')
let s:dein_vim_dir=s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:vim_tmp_dir=expand('~/.cache/vim')

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:vim_tmp_dir)
    call mkdir(s:vim_tmp_dir, 'p')
  endif
  if !isdirectory(s:dein_vim_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_vim_dir
  endif
  execute 'set runtimepath^=' . s:dein_vim_dir
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#add(s:dein_vim_dir)
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/neomru.vim')
  call dein#add('dracula/vim', {'merged': 0})
  call dein#source('dracula')
  call dein#add('itchyny/lightline.vim')
  call dein#add('thinca/vim-quickrun')
  call dein#add('AndrewRadev/linediff.vim')
  call dein#add('jremmen/vim-ripgrep')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif


" file
set autoread
set hidden
set noswapfile
set nobackup

" input
set backspace=indent,eol,start
set formatoptions=lmoq
set clipboard=unnamed,autoselect
set virtualedit=block
inoremap ¥ \

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
set statusline=%f%m%=[%l:%c][0x%02B]%y[%{&fileencoding}][%{&fileformat}]

" backup
let &directory=s:vim_tmp_dir
let &backupdir=s:vim_tmp_dir
let &undodir=s:vim_tmp_dir

" encoding
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932

" dracula
let g:dracula_italic=0
colorscheme dracula

" quickrun
let g:quickrun_config={}
let g:quickrun_config._={'split': 'below'}

" unite
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1
let g:unite_enable_ignore_case=1
let g:unite_enable_smart_case=1

nnoremap [unite] <Nop>
nmap <Space> [unite]

nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file file/new<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]r :<C-u>Unite file_rec/async:!<CR>
nnoremap <silent> [unite]g :<C-u>Unite file_rec/git:!<CR>

au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" neomru
if has('win32unix')
  let g:neomru#file_mru_ignore_pattern='^/'
  let g:neomru#directory_mru_ignore_pattern='^/'
endif

" matchit
source $VIMRUNTIME/macros/matchit.vim
