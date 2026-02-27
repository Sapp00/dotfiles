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
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Mononoki" ]; })
    ];
  };
}
