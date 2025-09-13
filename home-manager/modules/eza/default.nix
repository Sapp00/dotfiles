{ lib
, config
, ...
}:

with lib;

let
  cfg = config.module.eza;
in {
  options = {
    module.eza.enable = mkEnableOption "Enables eza";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
    };

    # TODO: This does not work.
    home.shellAliases = {
      ls = "eza";
    };
  };
}
