vim.cmd.packadd('packer.nvim')
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'AndrewRadev/linediff.vim'
  use 'dracula/vim'
  use 'thinca/vim-quickrun'
  use 'tpope/vim-dadbod'
  use 'lambdalisue/fern.vim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'nvim-tree/nvim-web-devicons', opt = true}
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = {'nvim-lua/plenary.nvim'}
  }
  use 'neovim/nvim-lspconfig'
end)


-- backup
vim.opt.directory = '~/.cache/nvim'
vim.opt.backupdir = '~/.cache/nvim'
vim.opt.undodir = '~/.cache/nvim'

-- filetype
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'sql', 'lua'},
  command = 'set softtabstop=2 | set shiftwidth=2 | set expandtab'
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'help', 'qf', 'quickrun'},
  command = 'nnoremap <buffer> q :<C-u>q<CR>'
})

-- colorscheme
vim.g.dracula_italic = false
vim.cmd.colorscheme('dracula')

-- file
vim.opt.autoread = true
vim.opt.autochdir = true
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.viminfo = "'1000,f1,<500"

-- input
vim.opt.backspace = 'indent,eol,start'
vim.opt.formatoptions = 'lmoq'
vim.opt.clipboard = 'unnamedplus'
vim.opt.virtualedit = 'block'
vim.keymap.set('i', '<Char-0xa5>', '<Char-0x5c>', {noremap = true, silent = true})

-- indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = false

-- search
vim.opt.wrapscan = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- view
vim.opt.showmatch = true
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = {tab = '> '}
vim.opt.title = true
vim.opt.scrolloff = 5
vim.opt.display = 'lastline,uhex'
vim.opt.foldlevel = 99
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.api.nvim_command('highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE')

-- encoding
vim.opt.termencoding = 'UTF-8'
vim.opt.encoding = 'UTF-8'
vim.opt.fileencoding = 'UTF-8'
vim.opt.fileencodings = 'UTF-8,cp932'

-- misc
vim.opt.belloff = 'all'
vim.opt.modelines = 1

-- buffer
vim.keymap.set('n', '<C-n>', ':tabnext<CR>', {noremap = true})
vim.keymap.set('n', '<C-p>', ':tabprevious<CR>', {noremap = true})
vim.keymap.set('n', '<C-j>', ':bnext<CR>', {noremap = true})
vim.keymap.set('n', '<C-k>', ':bprevious<CR>', {noremap = true})

-- runner
vim.g.quickrun_config = {['_'] = {['outputter/buffer/opener'] = 'split'}}
vim.keymap.set('n', '<Leader>R', ':<C-u>Quickrun sh<CR>', {noremap = true, silent = true})
vim.keymap.set('v', '<Leader>R', ":<C-u>'<,'>QuickRun sh<CR>", {noremap = true, silent = true})

-- dbext

-- status
vim.opt.laststatus = 2
local function DbConnection()
  return "XXX"
end
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'dracula',
    component_separators = '',
    section_separators = ''
  },
  sections = {
    lualine_y = {DbConnection}
  }
}

-- finder
local tsBuiltin = require('telescope.builtin')
vim.keymap.set('n', '<Space>f', tsBuiltin.find_files, {})
vim.keymap.set('n', '<Space>g', tsBuiltin.git_files, {})
vim.keymap.set('n', '<Space>m', tsBuiltin.oldfiles, {})
vim.keymap.set('n', '<Space>b', tsBuiltin.buffers, {})

-- explorer
vim.keymap.set('n', '<Space>e', ':<C-u>Fern .<CR>', {})

-- lsp
local lspConfig = require('lspconfig')
local lspUtil = require('lspconfig.util')
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
    end
  end
})
lspConfig.gopls.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end
})

-- lsp:golang
lspConfig.gopls.setup {
  cmd = {'gopls', 'serve'},
  filetypes = {'go', 'gomod'},
  root_dir = lspUtil.root_pattern('go.work', 'go.mod', '.git'),
  settings = {
    gopls = {
      analyses = {
        unsedparams = true
      },
      staticcheck = true
    }
  }
}
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({context = {only = {'source.organizaImports'}}, apply = true})
  end
})

-- lsp:python

-- tweak diff colors

-- copy path to clipboard
vim.keymap.set('n', '<Leader><Char-0x5c>', ':let @+ = expand("%:p")<CR>', {noremap = true, silent = true})

-- search selected word
vim.keymap.set('v', '*', 'y/\\V<C-r>=escape(@", "/\")<CR><CR>', {noremap = true})
