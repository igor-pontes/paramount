{ pkgs, lib, bling, wsmcolor, wsmupower, layout-machi, ... }:
let 
  lua-pam = with pkgs; (stdenv.mkDerivation {
    name = "lua-pam";
    buildInputs = [ pam lua ];
    nativeBuildInputs = [ cmake ];
    src = fetchFromGitHub {
      owner = "fafuja";
      repo = "lua-pam";
      rev = "master";
      sha256 = "sha256-Kn0ozckmgxs19TmCuSChdiYMch92eif7DTEK+UoBtjw=";
    };
    configurePhase = ''
      mkdir $out
      mv ./* $out
    '';
    buildPhase = ''
      cd $out
      SOURCE_DIR=$out
      cmake $out -B build
      cd build
      make
    '';
    installPhase = ''
      echo "$(pwd)"
      echo "$(ls)"
      mv ./liblua_pam.so ../liblua_pam.so
      cd ../ 
      rm -r $(ls | grep -v liblua_pam.so)
    '';
    outputs = [ "out" ];
  });
in
{
  home.file.".config/" = { 
    source = ../../files/config;
    recursive = true;
  };

  #home.file.".config/mpd/mpd.conf" = { 
  #  source = ../../files/mpd/mpd.conf;
  #  recursive = true;
  #};

  home.file.".config/awesome/modules/lockscreen/lib" = { 
    source = lua-pam;
    recursive = true;
  };

  home.file.".config/awesome/modules/bling" = { 
    source = bling;
    recursive = true;
  };

  home.file.".config/awesome/modules/color" = { 
    source = wsmcolor;
    recursive = true;
  };

  home.file.".config/awesome/modules/layout-machi" = { 
    source = layout-machi;
    recursive = true;
  };

  home.file.".config/awesome/modules/awesome-battery_widget" = { 
    source = wsmupower;
    recursive = true;
  };

  home.file.".Xresources".source = ../../files/misc/home/.Xresources;

  home.file.".xinitrc".source = ../../files/misc/home/.xinitrc;

  home.file.".zprofile".source = ../../files/misc/home/.zprofile;

  home.file.".custom_zsh" = {
    source = ../../files/misc/home/.custom_zsh; 
    recursive = true;
  };

  home.file.".local/share/fonts" = {
    source = ../../files/misc/fonts; 
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
