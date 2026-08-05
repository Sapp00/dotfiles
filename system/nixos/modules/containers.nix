{
  lib,
  config,
  pkgs,
  username,
  docker ? false,
  ...
}:

with lib;

{
  config = mkIf docker {
    # Enable Docker
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
      };
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    # Add user to docker group
    users.users.${username}.extraGroups = [ "docker" ];

    # Install useful container tools
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}