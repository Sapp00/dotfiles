{ lib, pkgs, desktop, isWorkstation, ... }:

lib.mkIf isWorkstation {
  programs = lib.mkMerge [
    (lib.mkIf (desktop == "hyprland") {
      hyprland.enable = true;
    })
  ];

  services = {
    greetd = {
      enable = true;
      settings.default_session = {
        command = lib.mkMerge [
          (lib.mkIf (desktop == "hyprland")
            "${lib.getExe pkgs.greetd.tuigreet} --time --cmd Hyprland")
        ];
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  hardware.graphics.enable = true;

  security.rtkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = lib.mkIf (desktop == "hyprland") [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };
}
