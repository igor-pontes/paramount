{ pkgs, lib, stdenv, ... }:
{
  services.picom.enable = true;
  services.picom.backend = "glx";
  services.acpid.enable = true;

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
        defaultSession = "none+awesome";
	startx.enable = true;
    };
    tty = 0;
    modules = with pkgs.xorg; [ xhost xinit xinput xorgserver xf86inputjoystick xrandr ];
    windowManager.awesome = with pkgs; {
      enable = true;

      package = awesome.overrideAttrs (old: 
	let
	  luaEnv = lua.withPackages(ps: with ps; [ lgi ldoc ]);
	  python = python3.withPackages(ps: with ps; [ mutagen ]);
	in {

        version = "git";

 	# https://github.com/fortuneteller2k/nixpkgs-f2k/blob/master/overlays/window-managers.nix
        gtk3Support = true;
        cmakeFlags = old.cmakeFlags ++ [ "-DGENERATE_MANPAGES=OFF" ];
	buildInputs = old.buildInputs ++ [ pam python ];
 	GI_TYPELIB_PATH =
        let
          extraGIPackages = [ pango upower playerctl python ];
          mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
          extraGITypeLibPaths = lib.forEach extraGIPackages mkTypeLibPath;
        in
        lib.concatStringsSep ":" (extraGITypeLibPaths);
        patches = [];
	postPatch = ''
          patchShebangs tests/examples/_postprocess.lua
          patchShebangs tests/examples/_postprocess_cleanup.lua
        '';
        src = fetchFromGitHub {
          owner = "awesomewm";
          repo = "awesome";
          rev = "master";
          sha256 = "ZFjYKyzQiRgg5uHgMLeex6oOKDrXMhp9dxxHEm2xeH4=";
        };
	postInstall = ''
          # Don't use wrapProgram or the wrapper will duplicate the --search
          # arguments every restart
          mv "$out/bin/awesome" "$out/bin/.awesome-wrapped"
          makeWrapper "$out/bin/.awesome-wrapped" "$out/bin/awesome" \
            --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
	    --set LD_LIBRARY_PATH ${ lib.makeLibraryPath [ pam xorg.libXrandr cairo libinput ] } \
            --add-flags '--search ${luaEnv}/lib/lua/${lua.luaversion}' \
            --add-flags '--search ${luaEnv}/share/lua/${lua.luaversion}' \
	    --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
            --prefix PATH : ${ lib.makeBinPath [ redshift rofi brightnessctl inotify-tools xdo xdotool maim xcolor picom gpick imagemagick xorg.xinput ] }
          
          wrapProgram $out/bin/awesome-client \
            --prefix PATH : "${which}/bin"
	'';
      });

      luaModules = with pkgs.luaPackages; [
        luarocks 
      ];
    };
    layout = "us";
    xkbVariant = "";
    xautolock.enable = true;
  };
  environment.systemPackages = with pkgs; [
    xclip
    mpv
    feh
    mpc-cli
    xfce.thunar
    xbindkeys
    wezterm
    xdg-desktop-portal
    networkmanager
    lxappearance
    spotify
    acpi
    dbus
    alsa-utils
    ffmpeg
    xfce.xfce4-power-manager
    neovim
    sysstat
    materia-theme
    colloid-icon-theme
  ];
  # thunar file manager(part of xfce) related options
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}
