{ config, pkgs, ... }:
{
  imports = [
    ./codelangs/python.nix
    ./codelangs/rust.nix
    ./everyday.nix
    ./system-tools.nix
    ./terminal.nix
    ./nvim
    ./shells
    ./gaming.nix
  ];
}
