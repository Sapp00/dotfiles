{
  self,
  lib,
  pkgs,
  desktop,
  ...
}:
{
  imports = [
    "${self}/home-manager/desktops/${desktop}"
    "${self}/home-manager/desktops/common"
  ];
  
  /*imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${homeModules}/${module}") (builtins.attrNames (builtins.readDir homeModules))
  );*/
}
