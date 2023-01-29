" cd /path/to/vim/vim*/autoload
" curl -fLo plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" mkdir ~/.vim/plugged ~/.vim/tmp

call plug#begin('~/.vim/plugged')
Plug 'thinca/vim-quickrun'
Plug 'AndrewRadev/linediff.vim'
Plug 'itchyny/lightline.vim'
Plug 'dracula/vim'
Plug 'vim-scripts/dbext.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-fugitive'
Plug 'jremmen/vim-ripgrep'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'lambdalisue/fern.vim'
if exists('*g:LoadPlug')
  call g:LoadPlug()
endif
call plug#end()

source $VIMRUNTIME/macros/matchit.vim


" backup
set directory=~/.vim/tmp
set backupdir=~/.vim/tmp
set undodir=~/.vim/tmp

" filetype
au FileType sql set softtabstop=2 | set shiftwidth=2 | set expandtab
au FileType help,qf,quickrun nnoremap <buffer> q :<C-u>q<CR>

" dracula
let g:dracula_italic = 0
augroup dracula_customization
  au!
  autocmd ColorScheme dracula hi! link SpecialKey DraculaSubtle
augroup END
colorscheme dracula

" file
set autoread
set autochdir
set hidden
set noswapfile
set nobackup
set viminfo='1000

" input
set backspace=indent,eol,start
set formatoptions=lmoq
set clipboard=unnamed,autoselect
set virtualedit=block
inoremap <Char-0xa5> <Char-0x5c>

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

" encoding
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932

" misc
set belloff=all

" tab/buffer
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprevious<CR>

" quickrun
let g:quickrun_config = {}
let g:quickrun_config._ = {'outputter/buffer/opener': 'split'}
nnoremap <silent> <Leader>R :<C-u>QuickRun sh<CR>
vnoremap <silent> <Leader>R :<C-u>'<,'>QuickRun sh<CR>

" dbext
let g:dbext_default_display_cmd_line = 0
let g:dbext_default_prompt_for_parameters = 0
let g:dbext_default_MYSQL_cmd_options = '--default-character-set=utf8mb4'
function! DBextGetTableName() abort
  let table_name = expand("<cword>")
  if table_name == ""
    echoerr 'You must supply a table name'
    return ""
  endif
  return table_name
endfunction
function! DBextConcatOption(param, value, separator)
  if a:value == ""
    return ""
  else
    return a:param . a:value . a:separator
  endif
endfunction
function! DBextMysqlDDL(...)
  return dbext#DB_execSql('show create table `' . DBextGetTableName() . '`')
endfunction
function! DBextPgsqlDDL(...)
  let cmd = 'pg_dump ' .
    \ dbext#DB_getWType("cmd_options") .
    \ DBextConcatOption(' -d', dbext#DB_getWTypeDefault("dbname"), ' ') .
    \ DBextConcatOption(' -U', dbext#DB_getWTypeDefault("user"), ' ') .
    \ DBextConcatOption(' -h', dbext#DB_getWTypeDefault("host"), ' ') .
    \ DBextConcatOption(' -p', dbext#DB_getWTypeDefault("port"), ' ') .
    \ DBextConcatOption(' -t', DBextGetTableName(), ' ') .
    \ DBextConcatOption(' ', dbext#DB_getWTypeDefault("extra"), '') .
    \ ' -s'
  " -f ' . dbext#DB_getWTypeDefault("temp_file")
  return dbext#DB_execFuncWCheck("runCmd", cmd, "", "")
endfunction
nnoremap <silent> <Leader>sds :call DBextPgsqlDDL()<CR>

" vim-table-mode
let g:table_mode_corner_corner = '+'
vnoremap <silent> <Leader>tu :<C-u>'<,'>!perl -lne "@F = split(/ *\x7c */); print join(chr(0x9), splice(@F, 1, -1))"<CR>

" status
set laststatus=2
let g:lightline = {
  \   'active': {
  \     'right': [ ['lineinfo'], ['connection'], ['fileformat', 'fileencoding', 'filetype'] ]
  \   }
  \ }
let g:lightline.component_function = { 'connection': 'LightlineConnection' }
function! LightlineConnection()
  return exists(':DB_listOption') ? DB_listOption('profile') : (100 * line('.') / line('$')) . '%'
endfunction

" ctrlp
let g:ctrlp_map = '<Nop>'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
" let g:ctrlp_user_command = 'rg --files --color=never %s'
let g:ctrlp_match_window = 'bottom,btt,min:1,max:10,results:100'
" let g:ctrlp_mruf_exclude = '^\/'
let g:ctrlp_prompt_mappings = { 'PrtInsert()': ['<F8>'] }
nnoremap [ctrlp] <Nop>
nmap <space> [ctrlp]
nnoremap <silent> [ctrlp]f :<C-u>CtrlPCurFile<CR>
nnoremap <silent> [ctrlp]w :<C-u>CtrlPCurWD<CR>
nnoremap <silent> [ctrlp]g :<C-u>CtrlPRoot<CR>
nnoremap <silent> [ctrlp]m :<C-u>CtrlPMRU<CR>
nnoremap <silent> [ctrlp]b :<C-u>CtrlPBuffer<CR>

" fern
nnoremap <silent> [ctrlp]e :<C-u>Fern .<CR>

" asyncomplete
let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

" lsp
" let g:lsp_preview_float = 1
" let g:lsp_signature_help_enabled = 0
let g:lsp_diagnostics_enabled = 1
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/.vim/vim-lsp.log')
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_inlay_hints_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gD :tab LspDefinition<CR>
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-reference)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gy <plug>(lsp-type-definition)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  let g:lsp_format_sync_timeout = 1000

  nmap <buffer> gc <plug>(lsp-declaration)
  nmap <buffer> gn <plug>(lsp-document-diagnostics)
endfunction
augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" lsp:golang
" go install golang.org/x/tools/gopls@latest
if executable('gopls')
  augroup gopls
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
      \   'name': 'gopls',
      \   'cmd': {server_info->['gopls']},
      \   'whitelist': ['go'],
      \ })
    autocmd BufWritePre *.go call execute(['LspCodeActionSync source.organizeImports', 'LspDocumentFormatSync'])
  augroup END
endif

" lsp:python
" python3 -m pip install python-lsp-server python-lsp-black pylsp-mypy pyls-isort pyls-flake8 pyproject-flake8
if executable('pylsp')
  augroup pylsp
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
      \   'name': 'pylsp',
      \   'cmd': {server_info -> ['pylsp']},
      \   'allowlist': ['python'],
      \   'workspace_config': {'pylsp': {
      \     'configurationSources': ['flake8'],
      \     'plugins': {
      \       'pycodestyle': { 'enabled': v:true },
      \       'black': {'enabled': v:true, 'line_length': 119},
      \       'flake8': {'enabled': v:true, 'maxLineLength': 119, 'executable': 'pflake8'},
      \       'pylsp_mypy': {'enabled': v:true}
      \     }
      \   }}
      \ })
    autocmd BufWritePre *.py LspDocumentFormatSync
  augroup END
endif

" tweak diff colors
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

" copy path to clipboard
nnoremap <silent> <Leader>\ :let @+ = expand("%:p")<CR>


""""""""""
" local-scope .vimrc
""""""""""
" exec 'source ~/.vim/autoload/plug.vim'
"
" ripgrep
" function! LcdAndRg(path)
"   let l:keyword = input('Enter keyword to search for ' . a:path . ': ')
"   exec 'lcd' a:path '|' 'Rg' l:keyword
" endfunction
" nnoremap <silent> <Leader>gp :<C-u>call LcdAndRg('~/projects')<CR>

" dbext
" let g:dbext_default_history_file = expand('~/.vim/tmp/dbext_sql_history.txt')
" let g:dbext_default_profile_LOCAL = 'type=MYSQL:user=root:passwd=:dbname=mysql:host=localhost'
" let g:dbext_default_profile = 'None'
