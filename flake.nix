{
  description = "Home Assistant and Nix Configuration";
  
  inputs = {

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    stylix = {
      url = "github:danth/stylix";
    };
  };
  
  outputs = 
    { self, nix-darwin, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;

      inherit (nixpkgs.lib.filesystem) packagesFromDirectoryRecursive listFilesRecursive;

      stateVersion = "24.05";
      helper = import ./lib { inherit self inputs outputs stateVersion; };
    in{
      
      # nixOS
      nixosConfigurations = {
        devVM = helper.mkNixos {
          hostname = "devVM";
          desktop = "hyprland";
        };
        devPi = helper.mkNixos {
          hostname = "devPi";
          platform = "aarch64-linux";
        };
        
        iso-console = helper.mkNixos{
          hostname = "iso-console";
          username = "nixos";
        };
      };
      
      # non-NixOS
      homeConfigurations = {
        desktop = helper.mkHome {
          hostname = "MauriceDesktop";
        };

        osx = helper.mkHome {
          platform = "aarch64-darwin";
          desktop = "osx";
          hostname = "maurice-macbook";
        };
      };

      # Darwin
      # nix run nix-darwin -- switch --flake .#osx
      darwinConfigurations = {
        osx = helper.mkDarwin {
          hostname = "MBP-von-Maurice";
          platform = "aarch64-darwin";
        };
      };

      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      # custom packages; accessible via 'nix build', 'nix shell' etc.
      packages = helper.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # formatter for .nix files: accessible via 'nix fmt'
      formatter = helper.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}

