" cd /path/to/vim/vim*/autoload
" curl -fLo plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" mkdir ~/.vim/plugged ~/.vim/tmp

call plug#begin('~/.vim/plugged')

Plug 'thinca/vim-quickrun'
Plug 'jremmen/vim-ripgrep'
Plug 'AndrewRadev/linediff.vim'
Plug 'itchyny/lightline.vim'
" Plug 'derekwyatt/vim-scala'
Plug 'dracula/vim'
Plug 'vim-scripts/dbext.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-fugitive'
" Plug 'w0rp/ale'
" Plug 'tpope/vim-surround'
" Plug 'andymass/vim-matchup'
Plug 'ctrlpvim/ctrlp.vim'
if has('gui_running')
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/vim-lsp'
  " Plug 'SirVer/ultisnips'
  " Plug 'honza/vim-snippets'
endif
source $VIMRUNTIME/macros/matchit.vim

call plug#end()


" backup
set directory=~/.vim/tmp
set backupdir=~/.vim/tmp
set undodir=~/.vim/tmp

" filetype
au FileType sql set softtabstop=2 | set shiftwidth=2 | set expandtab

" dracula
let g:dracula_italic = 0
colorscheme dracula

" file
set autoread
set autochdir
set hidden
set noswapfile
set nobackup
set viminfo=

" input
set backspace=indent,eol,start
set formatoptions=lmoq
set clipboard=unnamed,autoselect
set virtualedit=block
" inoremap \ ¥
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
set splitbelow
set cursorline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

" encoding
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932

" ale
" let g:ale_lint_on_save = 0
" let g:ale_lint_on_filetype_changed = 0
" let g:ale_lint_on_text_changed = 0
" let g:ale_lint_on_enter = 0
" let g:ale_fix_on_save = 1
" let g:ale_fixers = {'php': ['prettier']}
" let g:ale_java_google_java_format_options = '--aosp'

" quickrun
let g:quickrun_config = {}
let g:quickrun_config._ = {'outputter': 'multi:buffer:variable', 'outputter/buffer/split': 'below', 'outputter/variable/name': '\@p'}
nnoremap <silent> <Leader>R :<C-u>QuickRun sh<CR>
vnoremap <silent> <Leader>R :<C-u>'<,'>QuickRun sh<CR>

" dbext
let g:dbext_default_display_cmd_line = 0
let g:dbext_default_MYSQL_cmd_options = '--default-character-set=utf8mb4'
function! DBextPostResult(db_type, buf_nr)
  execute 'normal ggVG"py'
endfunction
function! DBextMysqlDDL(...)
  if (a:0 > 0)
    let table_name = s:DB_getObjectAndQuote(a:1)
  else
    let table_name = expand("<cword>")
  endif
  if table_name == ""
    call s:DB_warningMsg( 'dbext:You must supply a table name' )
    return ""
  endif

  return dbext#DB_execSql('show create table `' . table_name . '`')
endfunction
nnoremap <unique> <Leader>sds :call DBextMysqlDDL()<CR>

" vim-table-mode
let g:table_mode_corner_corner = '+'
vnoremap <silent> <Leader>tu :<C-u>'<,'>!perl -lne "@F = split(/ *\x7c */); print join(chr(0x9), splice(@F, 1, -1))"<CR>

" status
set laststatus=2
let g:lightline = { 'active': { 'right': [ ['lineinfo'], ['connection'], ['fileformat', 'fileencoding', 'filetype', 'charvaluehex'] ] }, 'component': { 'charvaluehex': '0x%02B' } }
let g:lightline.component_function = { 'connection': 'LightlineConnection' }
function! LightlineConnection()
  return exists(':DB_listOption') ? DB_listOption('profile') : (100 * line('.') / line('$')) . '%'
endfunction

" ctrlp
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_user_command = 'rg --files --color=never %s'
let g:ctrlp_match_window = 'bottom,btt,min:1,max:10,results:100'
" let g:ctrlp_mruf_exclude = '^\/'
let g:ctrlp_prompt_mappings = { 'PrtInsert()': ['<c-\>', '<c-^>'] }
nnoremap [ctrlp] <Nop>
nmap <space> [ctrlp]
nnoremap <silent> [ctrlp]f :CtrlPCurWD<CR>
nnoremap <silent> [ctrlp]g :CtrlPRoot<CR>
nnoremap <silent> [ctrlp]m :CtrlPMRU<CR>
nnoremap <silent> [ctrlp]b :CtrlPBuffer<CR>

" lsp
let g:lsp_preview_float = 1
let lsp_signature_help_enabled = 0
" let g:lsp_diagnostics_enabled = 0
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
function! s:configure_lsp() abort
  setlocal omnifunc=lsp#complete
  nnoremap <buffer> <C-]> :<C-u>LspDefinition<CR>
  nnoremap <buffer> gd :<C-u>LspPeekDefinition<CR>
  nnoremap <buffer> gr :<C-u>LspReferences<CR>
  nnoremap <buffer> K :<C-u>LspHover<CR>
endfunction

" asyncomplete
let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

" golang
if has('gui_running') && executable('gopls')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
    \ 'whitelist': ['go'],
    \ })
  autocmd BufWritePre *.go LspDocumentFormatSync
  autocmd FileType go call s:configure_lsp()
endif

" java
" let s:lombok_path = expand('~/.vim/jdtls/lombok.jar')
" let s:jdtls_launcher = expand('~/.vim/jdtls/plugins/org.eclipse.equinox.launcher_1.5.700.v20200207-2156.jar')
" if has('gui_running') && executable('java') && filereadable(s:jdtls_launcher)
"   autocmd User lsp_setup call lsp#register_server({
"     \ 'name': 'eclipse.jdt.ls',
"     \ 'cmd': {server_info->[
"     \    'java',
"     \    '-javaagent:' . s:lombok_path,
"     \    '-Xbootclasspath/a:' . s:lombok_path,
"     \    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
"     \    '-Dosgi.bundles.defaultStartLevel=4',
"     \    '-Declipse.product=org.eclipse.jdt.ls.core.product',
"     \    '-Dlog.level=ALL',
"     \    '-noverify',
"     \    '-Dfile.encoding=UTF-8',
"     \    '-Xmx1G',
"     \    '-jar',
"     \    s:jdtls_launcher,
"     \    '-configuration',
"     \    expand('~/.vim/jdtls/config_win'),
"     \    '-data',
"     \    expand('~/.vim/jdtls/workspace')
"     \ ]},
"     \ 'whitelist': ['java'],
"     \ })
" endif
    " \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.git/..'))},

" python
if has('gui_running') && executable('pyls')
  augroup pylsp
    autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': { server_info -> ['pyls'] },
      \ 'whitelist': ['python'],
      \ 'workspace_config': { 'pyls': { 'plugins': {
      \   'pycodestyle': { 'enabled': v:false },
      \   'jedi_definition': { 'follow_imports': v:true, 'follow_builtin_imports': v:true }, }}}
      \ })
    autocmd FileType python call s:configure_lsp()
  augroup END
endif

" tweak diff colors
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

" copy path to clipboard
nnoremap <silent> <Leader>\ :let @+ = expand("%:p")<CR>
