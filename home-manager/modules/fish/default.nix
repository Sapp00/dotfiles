{ 
  lib
, config
, username
, pkgs
, homeModules
, ...
}:

with lib;

let
  #cfg = config.module.fish;
  cfg = builtins.trace "foo!" config.module.fish;
in {
  options = {
    module.fish.enable = mkEnableOption "Enables Fish";
  };



  config = mkIf cfg.enable {
 
  };
}
