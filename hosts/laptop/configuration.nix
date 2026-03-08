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
      networks.Ridderstraat2.psk = builtins.getEnv "WIFI_HOME_PW";
    };
  };
  time.timeZone = "Europe/Amsterdam";

  users.users.robert = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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
