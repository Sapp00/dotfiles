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
    self.inputs.disko.nixosModules.disko

    ./disko.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
}