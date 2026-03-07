{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-ollama.url = "github:NixOS/nixpkgs/8c809a146a140c5c8806f13399592dbcb1bb5dc4"; # Avoid rebuilding hipblaslt constantly.

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar-workspaces = {
      url = "path:/mnt/storage/nc/Personal/nixos/modules/waybar/modules/workspaces";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar-resources = {
      url = "path:/mnt/storage/nc/Personal/nixos/modules/waybar/modules/resources";
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
      nvf,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            nvf.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                users.robert = import ./home/home.nix;
                users.root = import ./home/home-root.nix;
              };
            }
          ];
          specialArgs = {
            inherit inputs;
            pkgs-ollama = import nixpkgs-ollama {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
        };
      };

      checks.x86_64-linux = {
        nixos = self.nixosConfigurations.nixos.config.system.build.toplevel;
      };
    };
}
