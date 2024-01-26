{ config, pkgs, pkgs-unstable, ... }:
let 
  #openrgb-rules = builtins.fetchurl {
  #  url = "https://openrgb.org/releases/release_0.9/60-openrgb.rules";
  #  sha256 = "sha256:0f5bmz0q8gs26mhy4m55gvbvcyvd7c0bf92aal4dsyg9n7lyq6xp";
  #};
in {
  imports =
    [
      ../../modules/system.nix
      ../../modules/awesome.nix
      ./hardware-configuration.nix
    ];

  #services.udev.extraRules = builtins.readFile openrgb-rules;
  environment.variables.EDITOR = "nvim";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "pc";

  networking.networkmanager.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  networking.firewall.enable = true;
  services.samba.openFirewall = true;
  networking.firewall.allowPing = true;

  services.xserver.videoDrivers = ["nvidia"];
  #services.xserver.videoDrivers = [ "amdgpu" ];
  services.samba = {
    enable = true;
    #package = pkgs.sambaFull;
    shares = {
      public = { 
	path = "/home/fafuja/games";
        "read only" = true;
        browseable = "yes";
        "guest ok" = "yes";
        comment = "Public samba share.";
	"force user" = "fafuja";
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };  

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.steam-hardware.enable = true;

  hardware.nvidia = {
    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    #open = true;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = pkgs-unstable.linuxPackages.nvidia_x11_production;
  };

  system.stateVersion = "23.05";

}
