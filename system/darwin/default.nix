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
  isLima,
  stateVersion,
  username,
  ...
}:
{
  imports = [
    inputs.nix-index-database.darwinModules.nix-index
    inputs.stylix.darwinModules.stylix

    inputs.home-manager.darwinModules.home-manager
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = import "${self}/home-manager" { inherit self inputs lib desktop outputs username isLima isWorkstation pkgs config stateVersion; };

  # Only install the docs I use
  documentation.enable = true;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = true;

  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://images.squarespace-cdn.com/content/v1/55c8073fe4b02a74ffe18e48/1516136461905-X2YASK3VZ9EU4YKKF8FX/dream_big__by_yuumei-dbygupq.jpg";
      sha256 = "1cd6d51e0f0d67a4ea2b06cd531075dd5649022549b41a411ce0caac0c2abfbe";
    };
  };

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

