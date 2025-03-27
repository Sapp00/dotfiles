{ self
, lib
, hostname
, pkgs
, ...
}:

let
  machineHardwareModulesPath = "${self}/system/machine/${hostname}/modules/hardware";
in {
  imports = [
    self.inputs.nixos-wsl.nixosModules.default
  ];

  wsl.enable = true;

}
