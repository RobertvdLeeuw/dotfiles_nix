{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Avoid rebuilding hipblaslt constantly.
    nixpkgs-ollama.url = "github:NixOS/nixpkgs/8c809a146a140c5c8806f13399592dbcb1bb5dc4";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar-modules = {
      url = "github:RobertVDLeeuw/waybar-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-ollama,
      home-manager,
      sops-nix,
      nvf,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/desktop/configuration.nix

            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                  pkgs-ollama = import nixpkgs-ollama {
                    system = "x86_64-linux";
                    config.allowUnfree = true;
                  };
                  hostType = "desktop";
                };
                users = {
                  robert = import ./hosts/desktop/home.nix;
                  root = import ./hosts/desktop/home-root.nix;
                };
                sharedModules = [ nvf.homeManagerModules.default ];
              };
            }
          ];
          specialArgs = {
            inherit inputs;
          };
        };

        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/laptop/configuration.nix

            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                  hostType = "laptop";
                };
                users = {
                  robert = import ./hosts/laptop/home.nix;
                  root = import ./hosts/laptop/home-root.nix;
                };
                sharedModules = [ nvf.homeManagerModules.default ];
              };
            }
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };

      shellEnv =
        { hostType }:
        {
          imports = [
            nvf.homeManagerModules.default

            ./modules/core
          ];

          my = {
            noGUI = false;
            noAI = false;
          };
        };

      checks.x86_64-linux = {
        desktop = self.nixosConfigurations.desktop.config.system.build.toplevel;
        laptop = self.nixosConfigurations.laptop.config.system.build.toplevel;
      };
    };
}
