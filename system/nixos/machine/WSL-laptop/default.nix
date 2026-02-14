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
  };

  networking.proxy = mkIf hasProxy {
    default = proxy;
    noProxy = "127.0.0.1,localhost,internal.domain";
  };
}