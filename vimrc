call plug#begin('~/.vim/plugged')

Plug 'thinca/vim-quickrun'
Plug 'jremmen/vim-ripgrep'
Plug 'AndrewRadev/linediff.vim'
Plug 'itchyny/lightline.vim'
Plug 'fatih/vim-go'
Plug 'derekwyatt/vim-scala'
Plug 'dracula/vim'
Plug 'vim-scripts/dbext.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-fugitive'
Plug 'w0rp/ale'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'

call plug#end()


" filetype
au FileType sql set softtabstop=2 | set shiftwidth=2 | set expandtab

" dracula
let g:dracula_italic = 0
colorscheme dracula

" file
set autoread
set hidden
set noswapfile
set nobackup
set viminfo=

" input
set backspace=indent,eol,start
set formatoptions=lmoq
set clipboard=unnamed,autoselect
set virtualedit=block
inoremap \ \

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
set splitbelow
set cursorline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" backup
set directory=~/.vim/tmp
set backupdir=~/.vim/tmp
set undodir=~/.vim/tmp

" encoding
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932

" ale
let g:ale_lint_on_save = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1
" let g:ale_fixers = {'php': ['prettier']}
" let g:ale_java_google_java_format_options = '--aosp'

" quickrun
let g:quickrun_config = {}
let g:quickrun_config._ = {'split': 'below'}
nnoremap <silent> <Leader>R :<C-u>QuickRun sh<CR>
vnoremap <silent> <Leader>R :<C-u>'<,'>QuickRun sh<CR>

" dbext
let g:dbext_default_display_cmd_line = 0
let g:dbext_default_MYSQL_cmd_options = '--default-character-set=utf8mb4'

" vim-table-mode
let g:table_mode_corner_corner = '+'
vnoremap <silent> <Leader>tu :<C-u>'<,'>!perl -lne "@F = split(/ *\x7c */); print join(chr(0x9), splice(@F, 1, -1))"<CR>

" status
set laststatus=2
let g:lightline = { 'active': { 'right': [ ['lineinfo'], ['connection'], ['fileformat', 'fileencoding', 'filetype', 'charvaluehex'] ] }, 'component': { 'charvaluehex': '0x%02B' } }

" ctrlp
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_user_command = 'rg --files --color=never %s'
let g:ctrlp_match_window = 'bottom,btt,min:1,max:10,results:100'
let g:ctrlp_mruf_exclude = '^\/'
nnoremap [ctrlp] <Nop>
nmap <space> [ctrlp]
nnoremap <silent> [ctrlp]f :CtrlPCurFile<CR>
nnoremap <silent> [ctrlp]m :CtrlPMRU<CR>
nnoremap <silent> [ctrlp]b :CtrlPBuffer<CR>

" golang
if $GOROOT != ''
  set runtimepath+=$GOROOT/misc/vim
endif

" matchit
source $VIMRUNTIME/macros/matchit.vim

" tweak diff colors
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

" copy path to clipboard
nnoremap <silent> <Leader>\ :let @+ = expand("%:p")<CR>
