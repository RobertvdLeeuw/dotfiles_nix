{
  description = "NixOS";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/a82ccc39b39b621151d6732718e3e250109076fa"; # TODO: Revert to unstable once ollama hipblaslt build cached.

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
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.robert = import ./home/home.nix;
              home-manager.users.root = import ./home/home-root.nix;
            }
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };

      checks.x86_64-linux = {
        nixos = self.nixosConfigurations.nixos.config.system.build.toplevel;
      };
    };
}
