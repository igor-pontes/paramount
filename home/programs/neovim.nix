{ pkgs, lib, ... }:
let 
  paramount-custom = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "paramount";
    version = "1";
    src = pkgs.fetchFromGitHub {
      owner = "fafuja";
      repo = "vim-colors-paramount";
      rev = "9a6ef496148ce3af9b9b7f330b3bc9ca83aec856";
      sha256 = "sha256-htcLdzV38ys3uFONLDutRnuOj9R7ksUttPjFEfkLyZw=";
    };
  };
in {
  programs.neovim = {
    enable = true;
    extraConfig = lib.fileContents ../../files/init.vim;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      iceberg-vim
      indent-blankline-nvim
      vim-surround
      vim-fugitive
      vim-move
      #awesome-vim-colorschemes
      paramount-custom
      telescope-nvim
      #LeaderF
      telescope-fzf-native-nvim
      gitsigns-nvim
      vim-repeat
      editorconfig-nvim
      vim-airline
      nvim-treesitter.withAllGrammars
      completion-treesitter
      nvim-treesitter-textobjects
      lazy-lsp-nvim
      YouCompleteMe
      telescope-live-grep-args-nvim
    ];
  };
}
