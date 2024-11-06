{ lib
, config
, ...
}:

with lib;

let
  cfg = config.module.yq;
in {
  options = {
    module.yq.enable = mkEnableOption "Enables yq";
  };

  config = mkIf cfg.enable {
    programs.yq = {
      enable = true;
    };
  };
}
