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
      # secretsFile = "/etc/nixos/.env";
      networks.Ridderstraat2.pskRaw = config.sops.placeholder."wifi/home/psk";
      # networks.Ridderstraat2.psk = "freewifi";
    };
  };

  services.libinput.touchpad.naturalScrolling = true;

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
