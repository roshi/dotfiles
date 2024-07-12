local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'AndrewRadev/linediff.vim',
  'dracula/vim',
  'thinca/vim-quickrun',
  'tpope/vim-dadbod',
  'tpope/vim-fugitive',
  {'nvim-lualine/lualine.nvim',dependencies = {'nvim-tree/nvim-web-devicons', opt = true}},
  {'nvim-treesitter/nvim-treesitter', build = ":TSUpdate"},
  {'nvim-telescope/telescope.nvim', tag = '0.1.2', dependencies = {'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter'}},
  {'nvim-telescope/telescope-file-browser.nvim', dependencies = {'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim'}},
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',

  'github/copilot.vim',
  -- {'akinsho/flutter-tools.nvim', lazy = false, dependencies = {'nvim-lua/plenary.nvim'}, config = true},
})

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
vim.opt.linespace = 1
vim.api.nvim_command('highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE gui=underline guifg=NONE guibg=NONE guisp=Gray50')

-- encoding
-- vim.opt.termencoding = 'UTF-8'
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

-- database
-- vim.g.dadbod_manage_dbext = 0
vim.keymap.set('n', '<Leader>sbp', function()
  vim.ui.select(vim.tbl_keys(vim.g.dadbods or {}), {
    prompt = 'Select dbext profile',
  }, function(prof)
    if prof == '' then
      return
    end
    vim.g.dbext_default_profile = prof
    vim.g.db = vim.g.dadbods[prof]
  end)
end, {noremap = true, silent = true})
vim.keymap.set('v', '<Leader>se', ":<C-u>'<,'>DB<CR><CR>", {noremap = true, silent = true})
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = {'*.dbout'},
  command = 'nnoremap <buffer> q :<C-u>bw!<CR>'
})

-- status
vim.opt.cmdheight = 0
require('lualine').setup({
  options = {
    theme = 'dracula',
    icons_enabled = true,
    -- component_separators = '',
    -- section_separators = ''
  },
  sections = {
    lualine_y = {function()
      return vim.g.dbext_default_profile
    end}
  }
})

-- finder
local telescope = require('telescope')
local tsactions = require('telescope.actions')
telescope.setup({
  defaults = {
    -- layout_strategy = 'vertical',
    -- borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
    mappings = {
      i = {
        ['<C-d>'] = tsactions.delete_buffer,
        ['<esc>'] = tsactions.close,
      }
    }
  },
  extension = {
    file_browser = {
      theme = 'ivy',
      hijack_netrw = true,
    }
  }
})
telescope.load_extension('file_browser')
vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  command = 'set filetype=',
})
local tsbuiltin = require('telescope.builtin')
vim.keymap.set('n', '<Space>f', tsbuiltin.find_files, {})
vim.keymap.set('n', '<Space>g', tsbuiltin.git_files, {})
vim.keymap.set('n', '<Space>m', tsbuiltin.oldfiles, {})
vim.keymap.set('n', '<Space>b', tsbuiltin.buffers, {})
vim.keymap.set('n', '<Space>e', ':<C-u>Telescope file_browser<CR>', {})

-- syntax
require('nvim-treesitter.configs').setup({
  ensure_installed = {'lua', 'typescript'},
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

-- completion
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = true}),
  }),
  sources = cmp.config.sources({
    {name = 'nvim_lsp'},
    {name = 'vsnip'},
  })
})

-- lsp
-- vim.lsp.set_log_level(vim.log.levels.DEBUG)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = {noremap = true, silent = true, buffer = ev.buf}
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  end
})
local lspconfig = require('lspconfig')
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

-- lsp:golang
lspconfig.gopls.setup({})

-- lsp:python
lspconfig.pyright.setup({})

-- lsp:typescript
lspconfig.tsserver.setup({})

-- lsp:flutter
-- require('flutter-tools').setup({})

-- tweak diff colors

-- keymap
vim.keymap.set('n', '<Leader><Leader>', ':let @+ = expand("%:p")<CR>', {noremap = true, silent = true})
vim.keymap.set('v', '*', 'y/\\V<C-r>=escape(@", "/\")<CR><CR>', {noremap = true})
vim.keymap.set('n', '<Esc><Esc>', ':nohl<CR>')
