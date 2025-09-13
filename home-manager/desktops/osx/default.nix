{ isWorkstation
, isLinux
, hyprlandEnable ? false
, swayEnable ? false
, wmEnable ? false
, ...
}:
{
  nixpkgs.overlays = [  ];

  module = {
    kitty.enable = true;
  };
}
