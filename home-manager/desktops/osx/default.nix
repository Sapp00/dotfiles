{ isWorkstation
, isLinux
, hyprlandEnable ? false
, swayEnable ? false
, wmEnable ? false
, ...
}:
{
  module = {
    nerdfonts.enable = true;
    kitty.enable = true;
  };
}
