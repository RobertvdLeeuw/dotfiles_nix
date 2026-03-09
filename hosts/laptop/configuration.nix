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

  sops.templates."wpa_supplicant" = {
    content = ''
      network={
        ssid="${config.sops.placeholder."wifi/home/ssid"}"
        psk="${config.sops.placeholder."wifi/home/psk"}"
      }
    '';
    owner = "wpa_supplicant";
    mode = "0440";
  };

  systemd.services.wpa_supplicant.serviceConfig.BindReadOnlyPaths = [
    "/run/secrets/rendered/wpa_supplicant"
  ];

  networking = {
    hostName = "nixos-lt";
    wireless = {
      enable = true;
      extraConfigFiles = [ config.sops.templates."wpa_supplicant".path ];
    };
  };

  services.libinput.touchpad.naturalScrolling = false;

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
