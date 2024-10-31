{
  description = "Home Assistant and Nix Configuration";
  
  inputs = {

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };
  
  outputs = 
    { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      inherit (nixpkgs.lib) nixosSystem genAttrs replaceStrings;
      inherit (nixpkgs.lib.filesystem) packagesFromDirectoryRecursive listFilesRecursive;

      systems = [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
      ];

      forAllSystems =
        function:
        genAttrs systems
          (system: function nixpkgs.legacyPackages.${system});

      nameOf = path: replaceStrings [ ".nix" ] [ "" ] (baseNameOf (toString path));
    in
    {
      packages = forAllSystems (
        pkgs:
        packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;

          directory = ./packages;
        }
      );

      nixosModules = genAttrs (map nameOf (listFilesRecursive ./modules)) (
        name: import ./modules/${name}.nix
      );

      homeModules = genAttrs (map nameOf (listFilesRecursive ./home)) (name: import ./home/${name}.nix);

      overlays = genAttrs (map nameOf (listFilesRecursive ./overlays)) (
        name: import ./overlays/${name}.nix
      );

      /*pkgs-unstable = forAllSystems (import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };*/

      nixosConfigurations = {
        dev-pi = nixpkgs.lib.nixoSystem rec {
          system = "aarch64-linux";

          specialArgs.nix-config = self;
          modules = listFilesRecursive ./hosts/nixos;
        };
        dev-vm = nixpkgs.lib.nixoSystem rec {
          system = "x86_64-linux";
          modules = listFilesRecursive ./hosts/nixos;

          SpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };

            nix-config = self;
          };
        };
      };
      
      # non-NixOS
      homeConfigurations = {
        desktop = home-manager.lib.homeManagerConfiguration rec{
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home.nix ];

          extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        };

        notebook = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./home.nix ];

          extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              system = "aarch64-darwin";
              config.allowUnfree = true;
            };
          };
        };
      };

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}

