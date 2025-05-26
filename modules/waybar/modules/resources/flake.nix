{
  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    nixpkgs.follows = "cargo2nix/nixpkgs";
  };
  outputs = { self, cargo2nix, nixpkgs }: 
    let
      name = "resources";  # Name in Cargo.toml

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [cargo2nix.overlays.default];
      };
      rustPkgs = pkgs.rustBuilder.makePackageSet {
        rustVersion = "1.75.0";
        packageFun = import ./Cargo.nix;
        # packageOverrides = pkgs: pkgs.rustBuilder.overrides.all;  # TODO: What is the actual effect of this?
      };
    in {
      packages.x86_64-linux.default = rustPkgs.workspace.${name} {};  # Nix build

      apps.x86_64-linux.default = {  # Nix run
        type = "app";
        program = "${self.packages.x86_64-linux.default}/bin/${name}";
      };

      devShells = {  # Nix develop
        default = rustPkgs.workspaceShell {  # TODO: Figure out why extra packages and shellHook don't do anything. 
          packages = [ 
            cargo2nix.packages.x86_64-linux.cargo2nix 
          ];
        };
      };

    };
}
