{
  self,
  homeModules,
  lib,
  pkgs,
  desktop,
  username,
  ...
}:
{
  imports = [
    ./eza
    ./fish
    ./go-task
    ./kitty
    ./neovim
    ./tmux
    ./python
  ];
  
  /*imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${homeModules}/${module}") (builtins.attrNames (builtins.readDir homeModules))
  );*/
}
