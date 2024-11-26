{
  homeModules,
  lib,
  pkgs,
  desktop,
  ...
}:
{
  imports = [
    ./eza
    ./fish
    ./go-task
    ./kitty
    ./neovim
    #./stylix
    ./tmux
  ];
  /*imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${homeModules}/${module}") (builtins.attrNames (builtins.readDir homeModules))
  );*/
}
