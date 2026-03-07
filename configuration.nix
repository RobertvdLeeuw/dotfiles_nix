{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  user = "robert";
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/sway/sway.nix

    # ./modules/prompt.nix

    ./modules/python.nix
    ./modules/rust.nix

    ./modules/nvim

    ./shells/bash.nix

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
    useDHCP = lib.mkDefault true;

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
        12567
      ];
    };
  };

  system = {
    stateVersion = "24.11"; # DO NOT TOUCH! Needed in case of backwards incompatible update.
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-VERSION"; # TODO: Change?
    };
  };

  nixpkgs = {
    # overlays = [
    #   (final: prev: {
    #     inherit (prev.lixPackageSets.stable)
    #       nixpkgs-review
    #       nix-eval-jobs
    #       nix-fast-build
    #       ;
    #   })
    # ];
    config = {
      allowUnsupportedSystem = true;
      allowUnfree = true;
      permittedInsecurePackages = [
        "qtwebengine-5.15.19"
      ];
    };
  };

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nixos-rocm.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixos-rocm.cachix.org-1:qxhpX+2DqG2lqJ5cNYcgFrDzFdqfJhWzfFSKFp5s6Bk="
      ];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };

  fonts.packages =
    with pkgs;
    [
      iosevka
      fira-code
      fira-code-symbols
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  time.timeZone = "Europe/Amsterdam";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };
  };

  location.provider = "geoclue2"; # For redshift.

  services = {
    blueman.enable = true;

    journald.extraConfig = "SystemMaxUse=50M";
    desktopManager.plasma6.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "robert";
      };
      sddm.enable = true;
      defaultSession = "sway";
    };

    xserver = {
      enable = true;
      xkb = {
        # Configure keymap in X11
        layout = "us";
        variant = "";
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    # postgresql = {
    #   enable = true;
    #   package = pkgs.postgresql_16;

    #   extensions = ps: with ps; [
    #       pgvector
    #     ];
    # };
  };

  security = {
    rtkit.enable = true;
    pam.services.sddm.kwallet.enable = false;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.${user} = {
      isNormalUser = true;
      description = "${user}";
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

  environment = {
    pathsToLink = [ "/share/zsh" ];

    plasma6.excludePackages = with pkgs.kdePackages; [
      # kwrite
      elisa
      kate
      konsole
      gwenview
      okular
      ark
      spectacle
    ];

    variables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };
  };

  programs = {
    zsh = {
      enable = true;
      # TODO: Integrate with shells/zsh.nix? (that's manager by homemanager)
      interactiveShellInit = ''
        any-nix-shell zsh --info-right | source /dev/stdin
      '';
    };
  };
}
