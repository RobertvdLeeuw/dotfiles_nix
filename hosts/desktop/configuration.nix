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
    ../../modules/wm/kde.nix
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
    syncthing = {
      settings = {
        folders = {
          "nc-storage" = {
            path = "/mnt/storage/nc";
            devices = [ "server" ];
            type = "sendonly"; # Desktop sends, server receives
            ignorePerms = false; # Preserve file permissions
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
