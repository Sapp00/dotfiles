{
  self,
  config,
  inputs,
  isWorkstation,
  desktop,
  lib,
  outputs,
  pkgs,
  stateVersion,
  username,
  isHomeManaged,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;

  # these are "system" modules that are imported. on NixOS they are not managed by Home Manager, so we need to import it manually in case we are running HM-only
  commonModules = "${self}/system/common";

  userModulesPath         = "${self}/home-manager/users/${username}";
  #userModulesPathExist    = builtins.pathExists userModulesPath;
  userModulesPathExist    = builtins.trace userModulesPath builtins.pathExists userModulesPath;

  nix-colors = inputs.nix-colors;

  homeDirectory = 
    if isDarwin then
      "/Users/${username}"
    else
      "/home/${username}";
in
{
  imports = 
    [
      nix-colors.homeManagerModules.default
    ] 
    ++ lib.optional isWorkstation "${self}/home-manager/desktops"
    ++ lib.optional userModulesPathExist userModulesPath
    ++ lib.optional isHomeManaged commonModules
  ;

  # we use rose-pine-dawn for all apps
  colorScheme = nix-colors.colorSchemes.rose-pine-moon;

  home = {
    inherit username;
    inherit homeDirectory;
    inherit stateVersion;
    packages = with pkgs; 
      [
        # dev tools
        go
        nodejs_22
        clang
        cmake
        moreutils
      ]
      ++ lib.optionals isLinux [
        figlet
      ]
      ++ lib.optionals isDarwin [
        coreutils
        nh
      ];

    file = {
    };

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  /*nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };*/


  programs.git.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
