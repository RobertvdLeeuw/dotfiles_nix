{ config, pkgs, ... }:
{
  imports = [
    ./codelangs/python.nix
    ./codelangs/rust.nix
    ./everyday.nix
    ./system-tools.nix
    ./terminal.nix
    ./nvim
    ./gaming.nix
  ];
}
