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
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

  services.openssh = {
    enable = true;
  };

  hardware.enableRedistributableFirmware = true;
}