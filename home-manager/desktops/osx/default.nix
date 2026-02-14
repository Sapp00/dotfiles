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
    nerdfonts.enable = true;
    kitty.enable = true;
  };
}
