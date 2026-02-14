{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.module.python;
in {
  options = {
    module.python.enable = mkEnableOption "Enables python3";
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.python3.withPackages (python-pkgs: [
        python-pkgs.pandas
        python-pkgs.requests
      ]))
    ];
  };
}
