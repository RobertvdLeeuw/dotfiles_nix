{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common-config.nix

    ../../modules/wm/sway/sway.nix
    ../../modules/wm/kde.nix
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

  users = {
    defaultUserShell = pkgs.zsh;
    users.robert = {
      isNormalUser = true;
      description = "robert";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "video" # For GPU access
      ];
    };
  };
}
