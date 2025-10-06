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
  isInstall,
  ...
}:
let
  isHomeManaged = false;
  desk = builtins.trace desktop desktop;
  homeModules = "${self}/home-manager/modules";
in
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index

    inputs.home-manager.nixosModules.home-manager
    ../common
    ./machine/${hostname}
    ./modules/nvidia.nix
  ];

  users.users.${username} = {
    name = username;
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit self
    inputs
    desktop
    pkgs
    username;
  };
  home-manager.sharedModules = [{
    imports = ["${self}/home-manager/modules"];
  }];
  home-manager.users.${username} = import "${self}/home-manager" { inherit self inputs lib desktop outputs username isWorkstation pkgs config stateVersion isHomeManaged; };

  environment = {
    shells = [ pkgs.zsh ];
    
    defaultPackages =
      with pkgs;
      lib.mkForce [
        coreutils-full
        micro
      ];

    systemPackages =
      with pkgs;
      [
        git
        nix-output-monitor
      ]
      ++ lib.optionals isInstall [
        nvd
        nvme-cli
        rsync
	#smartmontools
        sops
      ];

    variables = {
      EDITOR = "micro";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allow-unfree = true;
    };
  };

  nix = 
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "flakes nix-command";
        flake-registry = "";
        nix-path = config.nix.nixPath;
        trusted-users = [
          "root"
          "${username}"
        ];
        warn-dirty = false;
      };
      channel.enable = false;
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";

  programs = {
    command-not-found.enable = false;
    zsh = {
      enable = true;
      shellAliases = {
        nano = "micro";
      };
    };

    nano.enable = lib.mkDefault false;

    /*nh = {
      clean = {
        enable = true;
        extraArgs = "--keep-since 15d --keep 10";
      };
      enable = true;
      flake = "/home-manager/users/${username}/Zero/nix-config";
    };*/
    nix-index-database.comma.enable = isInstall;
    nix-ld = lib.mkIf isInstall {
      enable = true;
      libraries = with pkgs; [

      ];
    };
  };

  services = {
    fwupd.enable = isInstall;
    hardware.bolt.enable = true;
    #smartd.enable = isInstall;
  };

  system = {
    nixos.label = lib.mkIf isInstall "-";
    inherit stateVersion;
  };
}
