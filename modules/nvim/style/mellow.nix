{
  description = "NeoVim Mellow Theme";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plugin-mellow = {
      url = "github:mellow-theme/mellow.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      homeConfiguration."robert" =
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ ./../nvim.nix ];
          extraSpecialArgs = {inherit inputs;};
        };
    };
}
