{ pkgs, config, ... }: 
{
  home.file.".config/rofi" = {
    source = ../../files/rofi;
    recursive = true;
  };
}
