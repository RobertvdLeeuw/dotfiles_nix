{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # lix = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # lix.nixosModules.default

          # determinate.nixosModules.default

          ./configuration.nix
          # inputs.sops-nix.nixosModules.sops
          
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.robert = import ./home/home.nix;
            home-manager.users.root = import ./home/home-root.nix;
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };

    checks.x86_64-linux = {
      nixos = self.nixosConfigurations.nixos.config.system.build.toplevel;
    };
  };
}
