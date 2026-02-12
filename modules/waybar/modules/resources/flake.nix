{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      crane,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        craneLib = crane.mkLib pkgs;

        workspaces = craneLib.buildPackage {
          src = craneLib.cleanCargoSource ./.;
          strictDeps = true;
        };
      in
      {
        packages.default = workspaces;

        apps.default = {
          type = "app";
          program = "${workspaces}/bin/workspaces";
        };

        devShells.default = craneLib.devShell {
          packages = with pkgs; [
            rust-analyzer
            clippy
          ];
        };
      }
    );
}
