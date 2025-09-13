{
  self,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:
let
    homeModules = "${self}/system/common";
in
{
  imports = builtins.trace "inputs@common/default.nix: ${toString (builtins.attrNames inputs)}" (
    builtins.filter (module: lib.pathIsDirectory module) (
      map (module: "${homeModules}/${module}") (builtins.attrNames (builtins.readDir homeModules))
    )
  );
}
