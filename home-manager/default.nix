{
  self,
  config,
  inputs,
  isLima,
  isWorkstation,
  desktop,
  lib,
  outputs,
  pkgs,
  stateVersion,
  username,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;


  homeModules = "${self}/home-manager/modules";  
  userModulesPath         = "${self}/home-manager/users/${username}";
  #userModulesPathExist    = builtins.pathExists userModulesPath;
  userModulesPathExist    = builtins.trace userModulesPath builtins.pathExists userModulesPath;

  homeDirectory = 
    if isDarwin then
      "/Users/${username}"
    else if isLima then
      "/home/${username}.linux"
    else
      "/home/${username}";
in
{
  imports = 
    [
      "${homeModules}"
    ] 
    ++ lib.optional isWorkstation "${self}/home-manager/desktops/${desktop}"
    ++ lib.optional userModulesPathExist userModulesPath
  ;
  home = {
    inherit username;
    inherit homeDirectory;
    inherit stateVersion;
    packages = with pkgs; 
      [
        # dev tools
        (python3.withPackages (ppkgs: [
          ppkgs.virtualenv
        ]))
        go
        nodejs_22
        clang
        cmake
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
