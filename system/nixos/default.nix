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
let
  isHomeManaged = false;
in
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
    inputs.stylix.nixosModules.stylix
  ];

 users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = import "${self}/home-manager" { inherit self inputs lib desktop outputs username isLima isWorkstation pkgs config stateVersion isHomeManaged; };

  environment = {
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
        smartmontools
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
    fish = {
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
    smartd.enable = isInstall;
  };

  system = {
    nixos.label = lib.mkIf isInstall "-";
    inherit stateVersion;
  };
}
