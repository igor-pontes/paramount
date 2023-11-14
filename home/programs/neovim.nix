{ pkgs-unstable, lib, ... }:
let 
  paramount-custom = pkgs-unstable.vimUtils.buildVimPlugin {
    pname = "paramount";
    version = "1";
    src = pkgs-unstable.fetchFromGitHub {
      owner = "fafuja";
      repo = "vim-colors-paramount";
      rev = "6372d70e629a7485b262ec37437cad45a176acfc";
      sha256 = "sha256-5gH3Ni37Kq0St6AFsui1lGPuYKVzfSZma+HCtxJjvOM=";
    };
  };
in {
  programs.neovim = {
    enable = true;
    extraConfig = lib.fileContents ../../files/init.vim;
    package = pkgs-unstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs-unstable.vimPlugins; [
      telescope-file-browser-nvim
      luasnip
      cmp_luasnip
      cmp-nvim-lsp-signature-help
      comment-nvim
      iceberg-vim
      indent-blankline-nvim
      #ultisnips
      #cmp-nvim-ultisnips
      #cmp-vsnip
      #vim-vsnip
      friendly-snippets
      vim-surround
      vim-fugitive
      vim-move
      lspkind-nvim
      #awesome-vim-colorschemes
      paramount-custom
      #vim-illuminate
      nvim-cursorline
      telescope-nvim
      nerdtree
      #LeaderF
      telescope-fzf-native-nvim
      gitsigns-nvim
      vim-repeat
      editorconfig-nvim
      vim-airline
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer

      nvim-treesitter.withAllGrammars
      completion-treesitter
      nvim-treesitter-textobjects

      lazy-lsp-nvim
      #YouCompleteMe
      telescope-live-grep-args-nvim
    ];
  };
}
