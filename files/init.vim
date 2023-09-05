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
set number
set expandtab
set softtabstop=2
set autoindent
set wildmode=longest,list
set hlsearch
set mouse=v
set ignorecase
set showmatch
set ttyfast
set clipboard=unnamedplus
filetype plugin indent on
let g:ycm_autoclose_preview_window_after_completion = 1
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
" nnoremap <M-Up> ddkP
" nnoremap <M-Down> ddp
" nnoremap \\ :noh<return>
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files
" set spell                 " enable spell check (may need to download language package)

let g:ycm_language_server = 
  \ [ 
  \   {
  \     'name': 'ocaml',
  \     'cmdline': [ 'ocamllsp'],
  \     'filetypes': [ 'ocaml' ]
  \   }
  \ ]

lua << EOF

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

EOF
