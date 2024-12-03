{ self
, lib
, hostname
, pkgs
, ...
}:

let
  machineHardwareModulesPath = "${self}/system/machine/${hostname}/modules/hardware";
in {
  imports = [
    "/etc/nixos/hardware-configuration.nix"
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
}