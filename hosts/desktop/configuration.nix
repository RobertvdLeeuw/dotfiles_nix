{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common-config.nix

    ../../modules/wm/sway/sway.nix
    # ../../modules/wm/kde.nix
  ];

  systemd.services = {
    nix-daemon.serviceConfig = {
      MemoryMax = "28G";
      MemoryHigh = "24G";
    };
    NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  services = {
    displayManager.autoLogin = {
      enable = true;
      user = "robert";
    };

    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    syncthing = {
      settings = {
        folders = {
          "nc-storage" = {
            path = "/mnt/storage/nc";
            devices = [
              "server"
              "laptop"
            ];
            # type = "sendreceive";
            type = "sendonly";
            ignorePerms = false;
          };
        };
      };
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
        "i2c"
      ];
    };
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/mnt/storage/docker";
    };
  };
}
