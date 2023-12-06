{ pkgs, pkgs-unstable, lib, stdenv, ... }:
let
  getLuaPath = lib: dir: "${lib}/${dir}/lua/${pkgs.luajit.luaversion}";
  makeSearchPath = lib.concatMapStrings (
    path:
      " --search "
      + (getLuaPath path "share")
      + " --search "
      + (getLuaPath path "lib")
  );
  modules = with pkgs; [
    pkgs.lua5_4
  ];
  awesome-git = pkgs.awesome.overrideAttrs (old: 
    let
      luaEnv = pkgs.lua.withPackages(ps: with ps; [ luadbi-mysql luaposix ldbus lgi ldoc luarocks]);
      python = pkgs.python3.withPackages(ps: with ps; [ mutagen ]);
    in 
    with pkgs; {
    lua = pkgs.luajit;
    version = "git";
    # https://github.com/fortuneteller2k/nixpkgs-f2k/blob/master/overlays/window-managers.nix
    gtk3Support = true;
    cmakeFlags = old.cmakeFlags ++ [ "-DGENERATE_MANPAGES=OFF" ];
    GI_TYPELIB_PATH =
    let
      extraGIPackages = with pkgs; [ pango upower playerctl python ];
      mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
      extraGITypeLibPaths = lib.forEach extraGIPackages mkTypeLibPath;
    in
    lib.concatStringsSep ":" (extraGITypeLibPaths);
    patches = [];
    postPatch = ''
      patchShebangs tests/examples/_postprocess.lua
      patchShebangs tests/examples/_postprocess_cleanup.lua
    '';
    src = pkgs.fetchFromGitHub {
      owner = "awesomewm";
      repo = "awesome";
      fetchSubmodules = false;
      rev = "375d9d723550023f75ff0066122aba99fdbb2a93";
      sha256 = "sha256-9cIQvuXUPu8io2Qs3Q8n2WkF9OstdaGUt/+0FMrRkXk=";
    };
    postInstall = ''
      # Don't use wrapProgram or the wrapper will duplicate the --search
      # arguments every restart
      mv "$out/bin/awesome" "$out/bin/.awesome-wrapped"
      makeWrapper "$out/bin/.awesome-wrapped" "$out/bin/awesome" \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --set LD_LIBRARY_PATH ${ lib.makeLibraryPath [ pam xorg.libXrandr cairo libinput lua5_4 ] } \
        --add-flags '--search ${luaEnv}/lib/lua/${lua.luaversion}' \
        --add-flags '--search ${luaEnv}/share/lua/${lua.luaversion}' \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      
      wrapProgram $out/bin/awesome-client \
        --prefix PATH : "${which}/bin"
    '';
  });
in {
  services.acpid.enable = true;
  services.upower.enable = true;
  #hardware.bluetooth.enable = true;

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    dpi = 120;

    displayManager = {
        defaultSession = "none+awesome";
	startx.enable = true;
    };
    tty = 0;

    modules = with pkgs.xorg; [ xhost xinit xinput xorgserver xf86inputjoystick xrandr xinput xwininfo];

    windowManager.awesome = with pkgs; {
      enable = true;

      package = awesome-git;

      #luaModules = with pkgs.luaPackages; [
      #  luarocks 
      #  lgi
      #  ldbus
      #  luadbi-mysql
      #  luaposix
      #];
    };
    layout = "us";
    xkbVariant = "";
    xautolock.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    xclip
    lxrandr
    rofi
    redshift
    brightnessctl
    inotify-tools
    xdo
    xdotool
    maim
    playerctl
    xcolor
    picom-next
    gpick
    pam
    xorg.xinput
    xsel
    mpv
    feh
    mpc-cli
    xfce.thunar
    xbindkeys
    xdg-desktop-portal
    networkmanager
    lxappearance
    spotify
    acpi
    dbus
    alsa-utils
    ffmpeg
    # xfce.xfce4-power-manager
    sysstat
    pkgs-unstable.glibc
    (materia-theme.overrideAttrs (_: _: { src = fetchFromGitHub { owner = "fafuja"; repo = "materia-theme"; rev = "7e9ca315a12ce38f89c19a97a12000d9ee5141dd"; sha256 = "sha256-icTEgJdfAeIjngXgcxiJB9aiW+LHgIFkRbiBh4b//7I="; }; nativeBuildInputs = [ pkgs-unstable.meson pkgs-unstable.ninja pkgs-unstable.sassc pkgs.dart-sass ]; }))
    (colloid-icon-theme.override { schemeVariants = [ "dracula" ]; colorVariants = ["purple"]; })
  ];

  # thunar file manager(part of xfce) related options
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}
