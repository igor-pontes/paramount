{ config, pkgs, ... }:
{
  imports = [
    ./browsers.nix
    ./misc.nix
    ./git.nix
    ./neovim.nix
    ./media.nix
    ./vscode.nix
    ./xdg.nix
  ];
}
