{ lib
, config
, ...
}:

with lib;

let
  cfg = config.module.kitty;
in {
  options = {
    module.kitty.enable = mkEnableOption "Enables kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
  };
}
