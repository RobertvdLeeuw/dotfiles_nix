# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos-lt";
    wireless = {
      enable = true;
      networks.Ridderstraat2.psk = "*****"; # USE .env FOR THIS!
    };
  };
  time.timeZone = "Europe/Amsterdam";

  users.users.robert = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    wpa_supplicant
  ];

  system.stateVersion = "24.11"; # DON'T TOUCH!

}
