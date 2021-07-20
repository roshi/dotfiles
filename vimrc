" cd /path/to/vim/vim*/autoload
" curl -fLo plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" mkdir ~/.vim/plugged ~/.vim/tmp

call plug#begin('~/.vim/plugged')

Plug 'thinca/vim-quickrun'
Plug 'jremmen/vim-ripgrep'
Plug 'AndrewRadev/linediff.vim'
Plug 'itchyny/lightline.vim'
Plug 'dracula/vim'
Plug 'vim-scripts/dbext.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-fugitive'
" Plug 'w0rp/ale'
" Plug 'tpope/vim-surround'
" Plug 'andymass/vim-matchup'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
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

" tab
" nnoremap <C-H> :tabprevious<CR>
" nnoremap <C-L> :tabnext<CR>

" quickrun
let g:quickrun_config = {}
let g:quickrun_config._ = {'outputter/buffer/split': 'below'}
nnoremap <silent> <Leader>R :<C-u>QuickRun sh<CR>
vnoremap <silent> <Leader>R :<C-u>'<,'>QuickRun sh<CR>

" dbext
let g:dbext_default_display_cmd_line = 0
let g:dbext_default_prompt_for_parameters = 0
let g:dbext_default_MYSQL_cmd_options = '--default-character-set=utf8mb4'
function! DBextMysqlDDL(...)
  if (a:0 > 0)
    let table_name = s:DB_getObjectAndQuote(a:1)
  else
    let table_name = expand("<cword>")
  endif
  if table_name == ""
    call s:DB_warningMsg('dbext:You must supply a table name')
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
let g:lightline = { 'active': { 'right': [ ['lineinfo'], ['connection'], ['fileformat', 'fileencoding', 'filetype'] ] } }
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
let g:ctrlp_prompt_mappings = { 'PrtInsert()': ['<c-\>', '<c-q>'] }
nnoremap [ctrlp] <Nop>
nmap <space> [ctrlp]
nnoremap <silent> [ctrlp]f :CtrlPCurFile<CR>
nnoremap <silent> [ctrlp]w :CtrlPCurWD<CR>
nnoremap <silent> [ctrlp]g :CtrlPRoot<CR>
nnoremap <silent> [ctrlp]m :CtrlPMRU<CR>
nnoremap <silent> [ctrlp]b :CtrlPBuffer<CR>

" asyncomplete
let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

" lsp
" let g:lsp_preview_float = 1
" let g:lsp_signature_help_enabled = 0
" let g:lsp_diagnostics_enabled = 0
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/.vim/vim-lsp.log')
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-reference)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> gc <plug>(lsp-document-diagnostics)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *rs,*.go call execute('LspDocumentFormatSync')
endfunction
augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" lsp:golang
if has('gui_running') && executable('gopls')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
    \ 'whitelist': ['go'],
    \ })
  autocmd BufWritePre *.go LspDocumentFormatSync
endif

" lsp:java
" https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Java
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
"     \    expand('~/.vim/jdtls/config_' . (has('mac') ? 'mac' : 'win')),
"     \    '-data',
"     \    expand('~/.vim/jdtls')
"     \ ]},
"     \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/'))},
"     \ 'whitelist': ['java'],
"     \ })
" endif

" lsp:python
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
  augroup END
endif

" vsnip
" if has('gui_running')
"   let g:completion_enable_snippet = 'vim-vsnip'
"   let g:vsnip_extra_mapping = v:true
" 
"   imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
"   smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
"   
"   imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
"   smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
"   
"   imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
"   smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
"   imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
"   smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
"   
"   nmap        s   <Plug>(vsnip-select-text)
"   xmap        s   <Plug>(vsnip-select-text)
"   nmap        S   <Plug>(vsnip-cut-text)
"   xmap        S   <Plug>(vsnip-cut-text)
"   
"   let g:vsnip_filetypes = {}
"   let g:vsnip_filetypes.javascriptreact = ['javascript']
"   let g:vsnip_filetypes.typescriptreact = ['typescript']
" endif

" tweak diff colors
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

" copy path to clipboard
nnoremap <silent> <Leader>\ :let @+ = expand("%:p")<CR>
