{
  homeModules,
  lib,
  ...
}:

{
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: "${homeModules}/{module}") (builtins.attrNames (builtins.readDir homeModules))
  );
}
