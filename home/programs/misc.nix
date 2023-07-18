{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    zip
    unzip
    htop
    authy
    libnotify
    xdg-utils
    krita
    obsidian
    discord
    gnome.gucharmap
  ];

  programs = {
    
    ssh.enable = true;

    tmux = {
      enable = true;
      clock24 = true;
      extraConfig = ''
	set -s escape-time 0
      '';
    };

    jq.enable = true;

    zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -la";
        update = "sudo nixos-rebuild switch --flake /etc/nixos#pc";
        vim = "sudo nvim";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
	# So, that once you add a plugin in the array and restart iTerm2, 
	# all that Oh-My-ZSH needs to do is to fetch that already installed plugin from the plugin folder and give you a *seeming less experience.
        plugins = [ "git" "sudo" "copyfile" "copybuffer" "dirhistory" "history" ];
        theme = "alanpeabody";
      };
    };
  };
}
