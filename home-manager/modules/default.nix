{
  self,
  homeModules,
  lib,
  pkgs,
  desktop,
  username,
  inputs,
  ...
}:
{
  imports = [
    ./eza
    ./fish
    ./zsh
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
