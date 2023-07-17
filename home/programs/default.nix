{ config, pkgs, ... }:
{
  imports = [
    ./browsers.nix
    ./misc.nix
    ./git.nix
    ./media.nix
    ./vscode.nix
    ./xdg.nix
  ];
}
