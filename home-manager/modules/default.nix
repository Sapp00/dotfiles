{
  homeModules,
  lib,
  pkgs,
  ...
}:
let
  mod = builtins.trace "test" "${homeModules}";
in
{
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${mod}/${module}") (builtins.attrNames (builtins.readDir homeModules))
  );
}
