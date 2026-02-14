{
  self,
  homeModules,
  lib,
  pkgs,
  desktop,
  username,
  inputs,
  hostname ? "",
  isWSL ? false,
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
    ./nerdfonts
  ];

  /*imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${homeModules}/${module}") (builtins.attrNames (builtins.readDir homeModules))
  );*/
}
