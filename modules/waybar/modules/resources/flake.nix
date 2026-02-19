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

        resources = craneLib.buildPackage {
          src = craneLib.cleanCargoSource ./.;
          strictDeps = true;

          nativeBuildInputs = with pkgs; [
            makeWrapper
          ];

          postInstall = ''
            wrapProgram $out/bin/resources \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.rocmPackages.rocm-smi ]}
          '';
        };
      in
      {
        packages.default = resources;
        apps.default = {
          type = "app";
          program = "${resources}/bin/resources";
        };
        devShells.default = craneLib.devShell {
          packages = with pkgs; [
            rust-analyzer
            clippy
            rocmPackages.rocm-smi # Also available in dev shell
          ];
        };
      }
    );
}
