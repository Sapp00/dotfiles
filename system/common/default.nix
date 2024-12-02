{
  self,
  lib,
  pkgs,
  username,
  ...
}:
let
    homeModules = "${self}/system/common";
in
{
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${homeModules}/${module}") (builtins.attrNames (builtins.readDir homeModules))
  );
}
