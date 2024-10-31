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
      lib = nixpkgs.lib;

      mkHomeModule = pkgs: system: hostname {
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            
          };
        }
      };

      import-unstable = system:
        import nixpkgs-unstable {
          system = system;
          config.allowUnfree = true;
        }


      mkSystem = pkgs: system: hostname:
        pkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { networking.hostName = hostname; }
            # generic configuration
            ./modules/system/configuration.nix
            (./. + "/hosts/${hostname}/hardware-configuration.nix")
            home-manager.nixosModules.home-manager
            {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {
                pkgs-unstable = import-unstable.${system};
              };
            }
          ];
        }
    in{
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

