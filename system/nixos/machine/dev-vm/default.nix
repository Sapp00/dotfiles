{ self
, lib
, hostname
, pkgs
, efi
, disk
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
        efiSupport = efi;
        device = if efi then "nodev" else disk;
      };
      efi.canTouchEfiVariables = efi;
      timeout = 0;
    };

    initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "virtio_gpu" "9p" "9pnet_virtio" ];
  };

  hardware.enableRedistributableFirmware = true;

  virtualisation.vmware.guest.enable = true;

  services.openssh.enable = true;

  # Hyprland needs a software renderer fallback — VMware ARM guests lack Vulkan support
  systemd.services.greetd.environment = {
    WLR_RENDERER = "gles2";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBGL_ALWAYS_SOFTWARE = "1";
  };
}
