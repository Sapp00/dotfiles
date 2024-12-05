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
      grub = {
        enable = true;
        efiSupport = true;
      };
      timeout = 0;
    };

    initrd.availableKernelModules = [ "uas" "virtio_blk" "virtio_pci" ];
  };

  hardware.enableRedistributableFirmware = true;
}
