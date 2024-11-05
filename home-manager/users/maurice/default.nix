{ isWorkstation
, isLinux
, hyprlandEnable ? false
, swayEnable ? false
, wmEnable ? false
, ...
}:

let
  valTrue = builtins.trace "fufu" true;
in
{
  nixpkgs.overlays = [  ];
/*
  stylix.targets = {
    vscode.enable = false;
    helix.enable = false;
  };*/

  module = {
    #stylix.enable    = isWorkstation;

    btop.enable           = valTrue;
    #eza.enable            = true;
    #git.enable            = true;
    #fzf.enable            = true;
    #htop.enable           = true;
    #ripgrep.enable        = true;
    #lazygit.enable        = true;
    nvim.enable           = true;
    fish.enable           = true;

    /*user = {
      packages.enable = true;
    };*/
  };
}
