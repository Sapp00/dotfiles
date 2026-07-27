{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.nerdfonts;
in {
  options = {
    module.nerdfonts.enable = mkEnableOption "Enables nerdfonts";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.mononoki
    ];
  };
}
