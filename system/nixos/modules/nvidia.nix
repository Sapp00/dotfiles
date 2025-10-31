{ lib, pkgs, nvidia, isLaptop, isWSL, ... }:

let
  inherit (lib) mkIf mkMerge;

in {
  config = mkIf nvidia {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = mkMerge [
      {
        # Shared NVIDIA config
        powerManagement.enable = !isWSL;
        powerManagement.finegrained = false;
      }

      # WSL-specific configuration
      (mkIf isWSL {
        modesetting.enable = false;
        nvidiaSettings = false;
        open = true;
      })

      # Real system (non-WSL) configuration
      (mkIf (!isWSL) {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = false;

        # Laptop-specific: PRIME offloading
        prime = mkIf isLaptop {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };

          # These must be customized per machine if needed
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      })
    ];

    # CUDA support and unfree packages (WSL only)
    nixpkgs.config = mkIf isWSL {
      allowUnfree = true;
      cudaSupport = true;
    };

    # Environment packages
    environment.systemPackages = mkMerge [
      # Always install NVIDIA driver
      [ pkgs.linuxPackages.nvidia_x11 ]

      # WSL-specific: CUDA and diagnostics
      (mkIf isWSL [
        pkgs.cudatoolkit
        pkgs.xorg.xrandr
        pkgs.mesa-demos
        pkgs.xorg.xhost
      ])
    ];

    # WSL-specific environment
    environment.sessionVariables = mkIf isWSL {
      CUDA_PATH = "${pkgs.cudatoolkit}";
      CUDA_HOME = "${pkgs.cudatoolkit}";
      LD_LIBRARY_PATH = [
        "/usr/lib/wsl/lib"
        "${pkgs.linuxPackages.nvidia_x11}/lib"
        "${pkgs.cudatoolkit}/lib"
        "${pkgs.cudatoolkit}/lib64"
      ];
      EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
      EXTRA_CCFLAGS = "-I/usr/include";
      DISPLAY = ":0";
      LIBGL_ALWAYS_INDIRECT = "0";
    };

    # Boot-time kernel modules (non-WSL only)
    boot = mkIf (!isWSL) {
      kernelModules = [ "nvidia" ];
      extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
    };

    # X11 / graphical stack
    services = mkMerge [
      # Use NVIDIA as X server driver (non-WSL)
      (mkIf (!isWSL) {
        xserver.videoDrivers = [ "nvidia" ];
      })

      # Laptop power management services (non-WSL)
      (mkIf (isLaptop && !isWSL) {
        thermald.enable = true;
        tlp = {
          enable = true;
          settings = {
            RUNTIME_PM_ON_AC = "auto";
            RUNTIME_PM_ON_BAT = "auto";
          };
        };
      })
    ];
  };
}
