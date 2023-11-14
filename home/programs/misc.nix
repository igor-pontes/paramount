{ pkgs, config, ... }:
#let microsoft-edge = pkgs.microsoft-edge.overrideAttrs (old: {
#  src = pkgs.fetchurl {
#    url = "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_116.0.1938.62-1_amd64.deb";
#    sha256 = "sha256-e2y4y7BySfOJvcQviNOMW0/JO2CKCpNnhrGP7N86LX0=";
#  };
#}); 
#in 
{
  home.packages = with pkgs; [
    zip
    gcc
    unzip
    virt-manager
    coq
    coqPackages.coqide
    conda
    #microsoft-edge
    libreoffice
    htop
    octave
    ripgrep
    fzf
    gparted
    authy
    libnotify
    xdg-utils
    krita
    #inkscape
    obsidian
    discord
    gnome.gucharmap
    python312
  ];

  programs = {
    
    ssh.enable = true;

    tmux = {
      enable = true;
      clock24 = true;
      terminal = "tmux-256color";
      extraConfig = ''
	set-option -g xterm-keys on
	set -s escape-time 0
      '';
      plugins = with pkgs; [
	tmuxPlugins.better-mouse-mode
      ];
    };

    jq.enable = true;

    zsh = {
      enable = true;
      enableAutosuggestions = true;

      initExtra = ''
      	export TERM=tmux-256color
        calc() {
          local input=$1
          local result=$(python -c "print($input)")
          echo "$result"
        }
      '';
      shellAliases = {
        ll = "ls -la";
        activate = "source ./venv/bin/activate";
        update = "sudo nixos-rebuild switch --flake /etc/nixos#pc";
	deleteold = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system";
        #vim = "sudo nvim";
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
