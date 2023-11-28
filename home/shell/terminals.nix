{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 1.0;
      window.dynamic_padding = true;
      window.padding.x = 5;
      window.padding.y = 0;

      font.offset.y = 1;
      font.normal.family = "AestheticIosevka";
      font.normal.style = "Regular";
      font.size = 12.0;
      scrolling.history = 10000;

      colors = {
        primary.background = "0x121212";
        primary.foreground = "0xF1F1F1";

        cursor.text = "0x666666";
        cursor.cursor = "0xFFFFFF";

        normal.black = "0x000000";
        normal.red = "0xC20814";
        normal.green = "0x10A778";
        normal.yellow = "0xA89C14";
        normal.magenta = "0xa790d5";
        normal.blue = "0x666666";
        normal.cyan = "0xA8A8A8";
        normal.white = "0xC7C7C7";

        bright.black = "0x262626";
        bright.red = "0xE32733";
        bright.green = "0x5FD7A7";
        bright.yellow = "0xffff87";
        bright.magenta = "0x9b72cf";
        bright.blue = "0x4e4e4e";
        bright.cyan = "0x767676";
        bright.white = "0xFFFFFF";
      };
    };
  };
}
