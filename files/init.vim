set nocompatible
set tabstop=2
set shiftwidth=2
set mouse=a
set cursorline
set background=dark
"colorscheme iceberg
colorscheme paramount
"let g:airline_theme='github'
let g:airline_theme='paramount'
syntax on
set number relativenumber
set expandtab
set softtabstop=2
set termguicolors
set autoindent
set wildmode=longest,list
set hlsearch
set mouse=v
set ignorecase
set showmatch
set ttyfast
set clipboard=unnamedplus
filetype plugin indent on
"set splitbelow
let g:ycm_autoclose_preview_window_after_completion = 1
set completeopt-=preview
nmap <leader>t :NERDTreeToggle<CR>
nnoremap <leader><space> <cmd>Telescope buffers<cr>
nnoremap <leader>? <cmd>Telescope oldfiles<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fs <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics<cr>
nnoremap <esc> :noh<return><esc>
map <M-Up> <A-k>
map <M-Down> <A-j>
noremap <C-J> <C-W>w
noremap <C-K> <C-W>W
noremap <C-L> <C-W>l
noremap <C-H> <C-W>h
noremap <C-Up> <C-Y>
noremap <C-Down> <C-E>
"noremap <C-D> <cmd>YcmCompleter GetHover<cr>
"nnoremap <A-W> :keepjumps normal! mi*`i<CR>
nnoremap <A-W> :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
"nmap <leader>D <plug>(YCMHover)
"nnoremap <leader>gl <cmd>YcmCompleter GoToDeclaration<CR>
"nnoremap <leader>gd <cmd>YcmCompleter GoToDefinition<CR>
nnoremap gb <C-o>
nnoremap gn <C-i>
" nnoremap <M-Up> ddkP
" nnoremap <M-Down> ddp
" nnoremap \\ :noh<return>
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files
" set spell                 " enable spell check (may need to download language package)

lua << EOF

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.ocamllsp.setup {}
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}

local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup {
      snippet = {
         expand = function(args)
	   vim.fn["vsnip#anonymous"](args.body)
           -- require('luasnip').lsp_expand(args.body)
	   -- vim.fn["UltiSnips#Anon"](args.body)
         end,
      },
      formatting = {
         format = lspkind.cmp_format {
            with_text = true,
            menu = {
               buffer   = "[buf]",
               nvim_lsp = "[LSP]",
               path     = "[path]",
	       vsnip 	= "[Snippet]",
            },
         },
      },
      mapping = cmp.mapping.preset.insert({
         ['<C-Up>'] = cmp.mapping.scroll_docs(-4),
         ['<C-Down>'] = cmp.mapping.scroll_docs(4),
         ['<C-Space>'] = cmp.mapping.complete(),
         ['<A-w>'] = cmp.mapping.abort(),
         ['<CR>'] = cmp.mapping.confirm({
	   behavior = cmp.ConfirmBehavior.Insert,
	   select = true,
	 }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	 ['<A-e>'] = function(fallback)
	  local col = vim.fn.col('.') - 1
	  if cmp.visible() then
	    cmp.select_next_item(select_opts)
	  elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
	    fallback()
	  else
	    cmp.complete()
	  end
	 end,
      }),
      sources = cmp.config.sources({
	 { name = 'nvim_lsp_signature_help' },
         { name = 'buffer' },
         { name = 'nvim_lsp' },
	 { name = 'vsnip' },
         -- { name = 'luasnip' },
	 -- { name = 'ultisnips' },
         { name = 'path' },
      }),
      experimental = {
         ghost_text = true
      }
}

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', '<C-d>', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>t', vim.lsp.buf.type_definition, opts)
	end,
})

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      }
    },
  },
}

require('lazy-lsp').setup {
  excluded_servers = {
    "sqls", "ccls", "zk",
  },
  preferred_servers = {
    haskell = { "hls" },
    rust = { "rust_analyzer" },
    elixir = {"elixir-ls"},
  },
}

require('telescope').load_extension('fzf')

require('gitsigns').setup {
  signs = {
    add = {text = '▎'},
    change = {text = '▎'},
    delete = {text = '➤'},
    topdelete = {text = '➤'},
    changedelete = {text = '▎'},
  }
}

require('indent_blankline').setup {
  char = '▏',
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  use_treesitter = true,
  show_current_context = false
}

require('nvim-cursorline').setup {
  cursorline = {
    enable = false,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}

EOF
