{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    # images
    imv
    # games
    #steam
    (godot_4.overrideAttrs ( old: rec {
    	version = "4.1.1-stable";
	src = fetchFromGitHub {
	  owner = "godotengine";
	  repo = "godot";
	  rev = "4.1.1-stable";
	  hash = "sha256-v9qKrPYQz4c+xkSu/2ru7ZE5EzKVyXhmrxyHZQkng2U=";
	};
    }))
  ];

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
      scripts = [pkgs.mpvScripts.mpris];
    };

    obs-studio.enable = true;

  };

  services = {
    playerctld.enable = true;
  };
}
