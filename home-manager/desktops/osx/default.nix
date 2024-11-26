{ isWorkstation
, isLinux
, hyprlandEnable ? false
, swayEnable ? false
, wmEnable ? false
, ...
}:
{
  nixpkgs.overlays = [  ];
/*
  stylix.targets = {
    vscode.enable = false;
    helix.enable = false;
  };*/

  module = {
    kitty.enable = true;
  };
}
