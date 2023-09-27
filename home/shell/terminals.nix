{ pkgs, ... }:
{
  programs.alacritty = {
    #enable = false;
    settings = {
      window.opacity = 0.95;
      window.dynamic_padding = true;
      window.padding = {
        x = 5;
        y = 5;
      };
      font.size = 17.0;
      scrolling.history = 10000;
    };
  };
}
