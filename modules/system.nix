{ config, pkgs, ... }:
{
  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";
  
  environment.systemPackages = with pkgs; [
    wget
    pciutils
    cifs-utils
    curl
    socat
    git
    lm_sensors
    neofetch
    #nnn
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  #virtualisation = {
  #  libvirtd = {
  #    enable = true;
  #    qemu.ovmf.enable = true;
  #  };
  #};
  security.rtkit.enable = true; 
  sound.enable = true;
  security.polkit.enable = true;
  services.printing.enable = true;

  fonts = {
    fonts = with pkgs; [
      material-icons
      iosevka
      roboto
    ];
  };

  programs.zsh.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";         # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  users.users.fafuja = {
    isNormalUser = true;
    description = "fafuja";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };
}
