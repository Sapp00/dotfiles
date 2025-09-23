{ self
, lib
, hostname
, pkgs
, hasProxy
, proxy
, ...
}:

with lib;

let
  machineHardwareModulesPath = "${self}/system/machine/${hostname}/modules/hardware";
in {
  imports = [
    self.inputs.nixos-wsl.nixosModules.default
  ];

  wsl.enable = true;

  # Enable NVIDIA GPU support for WSL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA configuration for WSL - minimal setup for CUDA only
  hardware.nvidia = {
    # Modesetting disabled for WSLg compatibility
    modesetting.enable = false;
    
    # Disable NVIDIA settings menu (conflicts with WSLg)
    nvidiaSettings = false;
    
    # Use open source driver for WSL2
    open = true;
    
    # Disable power management for WSL
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };

  # Add CUDA support
  nixpkgs.config = {
    cudaSupport = true;
    allowUnfree = true;
  };

  # Add NVIDIA, CUDA, and X11 packages to system environment
  environment.systemPackages = with pkgs; [
    cudatoolkit
    linuxPackages.nvidia_x11
    xorg.xrandr
    mesa-demos
    xorg.xhost
  ];

  # Set up CUDA and display environment variables for WSL2
  environment.sessionVariables = {
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

  networking.proxy = mkIf hasProxy {
    default = proxy;
    noProxy = "127.0.0.1,localhost,internal.domain";
  };
}