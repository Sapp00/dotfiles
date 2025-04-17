{ lib, config, pkgs, homeModules, inputs, ... }@args:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs.unstable; [
    nerd-fonts.iosevka
  ];
}
