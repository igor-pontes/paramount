{ pkgs, lib, ... }:
let 
  paramount-custom = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "paramount";
    version = "1";
    src = pkgs.fetchFromGitHub {
      owner = "fafuja";
      repo = "vim-colors-paramount";
      rev = "d309ac579ab9c4045330a6e180048635ba09ba5e";
      sha256 = "sha256-JzqxHCGkaI1A42G1Z0lYOYLTjJPnPViL2LrbZXOP6M8=";
    };
  };
in {
  programs.neovim = {
    enable = true;
    extraConfig = lib.fileContents ../../files/init.vim;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      cmp-nvim-lsp-signature-help
      iceberg-vim
      indent-blankline-nvim
      #ultisnips
      #cmp-nvim-ultisnips
      cmp-vsnip
      vim-vsnip
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
