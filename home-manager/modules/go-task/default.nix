{ lib
, config
, ...
}:

with lib;

let
  cfg = config.module.go-task;
in {
  options = {
    module.go-task.enable = mkEnableOption "Enables go-task";
  };


}
