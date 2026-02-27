{ self
, lib
, hostname
, pkgs
, hasProxy
, proxy
, username
, ...
}:

with lib;

let
  machineHardwareModulesPath = "${self}/system/machine/${hostname}/modules/hardware";
in {
  imports = [
    self.inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = true;
    wslConf.network.hostname = hostname;
  };

  # Force X11 for GUI applications to avoid Wayland hibernation issues
  environment.sessionVariables = {
    # Force X11 backend for GUI toolkits
    GDK_BACKEND = "x11";
    QT_QPA_PLATFORM = "xcb";
    SDL_VIDEODRIVER = "x11";
    CLUTTER_BACKEND = "x11";
    
    # Force X11 for specific applications
    KITTY_DISABLE_WAYLAND = "1";
    
    # Disable Wayland for specific applications  
    WAYLAND_DISPLAY = "";
    XDG_SESSION_TYPE = "x11";
    
    # Ensure DISPLAY is set for X11
    DISPLAY = ":0";
  };


  networking.proxy = mkIf hasProxy {
    default = proxy;
    noProxy = "127.0.0.1,localhost,internal.domain";
  };
}