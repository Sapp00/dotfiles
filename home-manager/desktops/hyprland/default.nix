{ isWorkstation
, isLinux
, ...
}:
{
  nixpkgs.overlays = [  ];

  module = {
    kitty.enable = true;
  };
}
