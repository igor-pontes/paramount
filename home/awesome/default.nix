#{ pkgs, lib, yoru-theme, ... }:
{ pkgs, lib, ... }:
#let 
#  lua-pam = with pkgs; (stdenv.mkDerivation {
#    name = "lua-pam";
#    buildInputs = [ pam lua ];
#    nativeBuildInputs = [ cmake ];
#    src = fetchFromGitHub {
#      owner = "skobman";
#      repo = "lua-pam";
#      rev = "master";
#      sha256 = "sha256-Kn0ozckmgxs19TmCuSChdiYMch92eif7DTEK+UoBtjw=";
#    };
#    # By default; this runs `make install`.
#    # # The install phase will fail if there is no makefile; so it is the
#    # best choice to replace with our custom code.
#    configurePhase = ''
#      mkdir $out
#      mv ./* $out
#    '';
#    buildPhase = ''
#      cd $out
#      SOURCE_DIR=$out
#      cmake $out -B build
#      cd build
#      make
#    '';
#    installPhase = ''
#      echo "$(pwd)"
#      echo "$(ls)"
#      mv ./liblua_pam.so ../liblua_pam.so
#    '';
#    outputs = [ "out" ];
#  });
#in
{
  home.file.".config/" = { 
    source = ../../files/yoru/config;
    recursive = true;
  };

  #home.file.".config/mpd/mpd.conf" = { 
  #  source = ../../files/mpd/mpd.conf;
  #  recursive = true;
  #};

  home.file.".config/awesome/modules/lockscreen/lib" = { 
    source = ../../files/lib/pam;
    recursive = true;
  };

  home.file.".Xresources".source = ../../files/yoru/misc/home/.Xresources;

  home.file.".xinitrc".source = ../../files/yoru/misc/home/.xinitrc;

  home.file.".local/share/fonts" = {
    source = ../../files/yoru/misc/fonts; 
    recursive = true;
  };

  home.file.".local/share/icons/Colloid-cursors" = {
    source = ../../files/Colloid-cursors; 
    recursive = true;
  };
  
  home.file.".local/share/icons/Colloid-dark-cursors" = {
    source = ../../files/Colloid-dark-cursors; 
    recursive = true;
  };

  home.file.".local/share/sRGB.icc" = {
    source = ../../files/sRGB.icc; 
    recursive = true;
  };
}
