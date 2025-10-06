{
  lib,
  pkgs,
  nvidia,
  isLaptop,
  hostname,
  ...
}:

with lib;

{
  config = mkIf nvidia {
    # Enable graphics
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # NVIDIA configuration
    hardware.nvidia = mkMerge [
      # Base NVIDIA configuration
      {
        # Enable NVIDIA settings menu
        nvidiaSettings = true;
        
        # Enable power management for laptops, disable for WSL
        powerManagement.enable = !((builtins.substring 0 3 hostname) == "WSL");
        powerManagement.finegrained = false;
      }
      
      # WSL-specific configuration
      (mkIf ((builtins.substring 0 3 hostname) == "WSL") {
        # Modesetting disabled for WSLg compatibility
        modesetting.enable = false;
        
        # Disable NVIDIA settings menu (conflicts with WSLg)
        nvidiaSettings = false;
        
        # Use open source driver for WSL2
        open = true;
      })
      
      # Non-WSL configuration (desktop/laptop)
      (mkIf (!((builtins.substring 0 3 hostname) == "WSL")) {
        # Required for modern NVIDIA GPUs
        modesetting.enable = true;
        
        # Use proprietary driver
        open = false;
        
        # Laptop-specific: Enable hybrid graphics support
        prime = mkIf isLaptop {
          # Enable NVIDIA Optimus support
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          
          # Default bus IDs - should be overridden per machine
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      })
    ];

    # Add CUDA support for WSL
    nixpkgs.config = mkIf ((builtins.substring 0 3 hostname) == "WSL") {
      cudaSupport = true;
      allowUnfree = true;
    };

    # NVIDIA packages
    environment.systemPackages = with pkgs; mkMerge [
      # Base packages for all NVIDIA systems
      [
        linuxPackages.nvidia_x11
      ]
      
      # WSL-specific packages
      (mkIf ((builtins.substring 0 3 hostname) == "WSL") [
        cudatoolkit
        xorg.xrandr
        mesa-demos
        xorg.xhost
      ])
    ];

    # WSL-specific environment variables
    environment.sessionVariables = mkIf ((builtins.substring 0 3 hostname) == "WSL") {
      CUDA_PATH = "${pkgs.cudatoolkit}";
      CUDA_HOME = "${pkgs.cudatoolkit}";
      # Fix LD_LIBRARY_PATH for WSL - put WSL lib first as per nixos wiki
      LD_LIBRARY_PATH = [
        "/usr/lib/wsl/lib"
        "${pkgs.linuxPackages.nvidia_x11}/lib"
        "${pkgs.cudatoolkit}/lib"
        "${pkgs.cudatoolkit}/lib64"
      ];
      EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
      EXTRA_CCFLAGS = "-I/usr/include";
      # WSLg display configuration
      DISPLAY = ":0";
      LIBGL_ALWAYS_INDIRECT = "0";
    };

    # Boot configuration for non-WSL systems
    boot = mkIf (!((builtins.substring 0 3 hostname) == "WSL")) {
      kernelModules = [ "nvidia" ];
      extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
    };

    # Services configuration
    services = mkMerge [
      # Load nvidia driver for Xorg and Wayland (non-WSL)
      (mkIf (!((builtins.substring 0 3 hostname) == "WSL")) {
        xserver.videoDrivers = [ "nvidia" ];
      })
      
      # Laptop-specific services
      (mkIf (isLaptop && !((builtins.substring 0 3 hostname) == "WSL")) {
        thermald.enable = true;
        tlp = {
          enable = true;
          settings = {
            # Optimize for hybrid graphics
            RUNTIME_PM_ON_AC = "auto";
            RUNTIME_PM_ON_BAT = "auto";
          };
        };
      })
    ];
  };
}