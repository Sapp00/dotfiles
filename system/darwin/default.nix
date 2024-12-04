{
  self,
  config,
  hostname,
  inputs,
  lib,
  outputs,
  desktop,
  pkgs,
  platform,
  isWorkstation,
  stateVersion,
  username,
  ...
}:
let
  isHomeManaged = false;
  desk = builtins.trace desktop desktop;
  homeModules = "${self}/home-manager/modules";
in
{
  imports = [
    inputs.nix-index-database.darwinModules.nix-index

    inputs.home-manager.darwinModules.home-manager
    ../common
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [{
    imports = [../../home-manager/modules];
  }];
  home-manager.extraSpecialArgs = {
    inherit self
    desktop
    username;
  };
  home-manager.users.${username} = import "${self}/home-manager" { inherit self inputs lib desktop outputs username isWorkstation pkgs config stateVersion isHomeManaged; };

  # Only install the docs I use
  documentation.enable = true;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = true;

  environment = {
    shells = [ pkgs.fish ];
    systemPackages = with pkgs; [
      git
      # m-cli
      mas
      nix-output-monitor
      nvd
      plistwatch
      sops
      home-manager
    ];

    variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${platform}";
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  nix = {
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  networking.hostName = hostname;
  networking.computerName = hostname;

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        nano = "micro";
        vim = "nvim";
      };
    };
    #gnupg.agent = {}
    info.enable = false;
    nix-index-database.comma.enable = true;
  };

  # TouchID for sudo
  #security.pam.enableSudoTouchIdAuth = true;

  services = {
    activate-system.enable = true;
    nix-daemon.enable = true;
  };

  system = {
    stateVersion = 5;
    activationScripts = {

    };
    checks = {
      verifyNixChannels = false;
    };
    defaults = {
      CustomUserPreferences = {
        "com.apple.AdLib" = {
          allowAppleePersonalizedAdvertising = false;
        };
        "com.apple.controlcenter" = {
          BatteryShowPercentage = true;
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.finder" = {
          _FXSortFoldersFirst = true;
          FXDefaultSearchScope = "SCcf"; # Search current folder by default
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
        };
        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = true;
          # Check for software updates daily, not just once per week
          ScheduleFrequency = 1;
          # Download newly available updates in background
          AutomaticDownload = 0;
          # Install System data files & security updates
          CriticalUpdateInstall = 1;
        };
        # Turn on app auto-update
        "com.apple.commerce".AutoUpdate = true;     
      };
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = false;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      menuExtraClock = {
        ShowAMPM = false;
        ShowDate = 1; # Always
        Show24Hour = true;
        ShowSeconds = false;
      };
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 300;
      };
      #smb.NetBIOSName = hostname;
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = true; # enable three finger drag
      };
    };
  };
}

