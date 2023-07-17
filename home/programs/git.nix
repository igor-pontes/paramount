{ pkgs, ... }: 
{
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;
    userName = "Igor Andrade";
    userEmail = "igoppop@gmail.com";
  };
}
