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
nnoremap <leader>f. <cmd>Telescope file_browser<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fs <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics<cr>
nnoremap <esc> :noh<return><esc>
map <M-Up> <A-k>
map <M-Down> <A-j>
noremap <C-A-j> <C-W>w
noremap <C-A-k> <C-W>W
noremap <C-A-l> <C-W>l
noremap <C-A-h> <C-W>h
noremap <C-Up> <C-Y>
noremap <C-Down> <C-E>
noremap <C-k> <S-Up>
noremap <C-j> <S-Down>
"noremap <C-D> <cmd>YcmCompleter GetHover<cr>
"nnoremap <A-W> :keepjumps normal! mi*`i<CR>
nnoremap <A-W> :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
"nmap <leader>D <plug>(YCMHover)
"nnoremap <leader>gl <cmd>YcmCompleter GoToDeclaration<CR>
"nnoremap <leader>gd <cmd>YcmCompleter GoToDefinition<CR>
"nnoremap gb <C-o>
"nnoremap gn <C-i>
nnoremap g] <C-o>
nnoremap g[ <C-i>
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

require("luasnip.loaders.from_vscode").load()
local cmp = require('cmp')
local lspkind = require('lspkind')
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
cmp.setup {
      snippet = {
         expand = function(args)
	   -- vim.fn["vsnip#anonymous"](args.body)
           require('luasnip').lsp_expand(args.body)
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
	['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
	['<C-n>'] = cmp.mapping.select_next_item(select_opts),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
	['<A-e>'] = cmp.mapping.abort(),
	['<C-y>'] = cmp.mapping.confirm({select = true}),
	['<CR>'] = cmp.mapping.confirm({select = false}),
	['<Tab>'] = cmp.mapping(function(fallback)
	  local col = vim.fn.col('.') - 1
	  if cmp.visible() then
	    cmp.select_next_item(select_opts)
	  elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
	    fallback()
	  else
	    cmp.complete()
	  end
	end, {'i', 's'}),
	['<S-Tab>'] = cmp.mapping(function(fallback)
	  if cmp.visible() then
	    cmp.select_prev_item(select_opts)
	  else
	    fallback()
	  end
	end, {'i', 's'}),
      }),
      sources = cmp.config.sources({
	 { name = 'nvim_lsp_signature_help' },
         { name = 'buffer' },
         { name = 'nvim_lsp' },
	 -- { name = 'vsnip' },
         { name = 'luasnip' },
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

require("telescope").setup {
  defaults = {
  },
  extensions = {
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      dir_icon = "",
      git_status = false,
    },
  },
}

require('telescope').load_extension('fzf')

require('telescope').load_extension('file_browser')

require('gitsigns').setup {
  signs = {
    add = {text = '▎'},
    change = {text = '▎'},
    delete = {text = '➤'},
    topdelete = {text = '➤'},
    changedelete = {text = '▎'},
  }
}

require('ibl').setup {
	indent = { char = "▏" },
}

require('Comment').setup {
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    ---Function to call before (un)comment
    pre_hook = nil,
    ---Function to call after (un)comment
    post_hook = nil,
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
