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

    initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
  };

  hardware.enableRedistributableFirmware = true;
}
