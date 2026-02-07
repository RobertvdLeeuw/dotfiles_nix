{ pkgs ? import <nixpkgs> {} }:

let
  cargo2nixSrc = pkgs.fetchFromGitHub {
    owner = "cargo2nix";
    repo = "cargo2nix";
    rev = "release-0.11.0";
    sha256 = "sha256-nz3zSO5a/cB/XPcP4c3cddUceKH9V3LNMuNpfV3TDeE="; # Update hash
  };
  
  cargo2nixOverlay = import "${cargo2nixSrc}/overlay";
  
  pkgsWithOverlay = import <nixpkgs> {
    overlays = [ cargo2nixOverlay ];
  };
  
  rustPkgs = pkgsWithOverlay.rustBuilder.makePackageSet {
    rustVersion = "1.75.0";
    packageFun = import ./Cargo.nix;
  };
in
  (rustPkgs.workspace.workspaces {})
