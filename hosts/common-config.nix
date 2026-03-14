{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops =
    let
      secretPaths = [
        "wifi/home/ssid"
        "wifi/home/psk"
        "services/syncthing-pw"
      ];
    in
    {
      defaultSopsFile = ../secrets.yaml;
      age.keyFile = "/var/lib/sops-nix/key.txt";
      secrets = lib.genAttrs secretPaths (_: { });
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

  networking = {
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
      ];
    };
  };

  services = {
    blueman.enable = true;

    journald.extraConfig = "SystemMaxUse=50M";
    displayManager = {
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

  services.syncthing = {
    enable = true;
    user = "robert"; # Your desktop user
    dataDir = "/home/robert";
    configDir = "/home/robert/.config/syncthing";
    openDefaultPorts = true;

    guiPasswordFile = config.sops.secrets."services/syncthing-pw".path;

    settings = {
      gui.user = "robert";

      devices = {
        "server".id = "J2TMKWI-DQJY6VG-LJQD4QP-D4XKLPB-CKD4KMJ-7J5E5TO-EEGS5UW-E6C2BAH";
        "desktop".id = "24PKA7Z-UWYQM46-UORQCZS-TKM3Z3F-YP2CL7Z-A5PTLI5-6EH5OKX-HZLMQAV";
        "laptop".id = "J267XXP-JPQEOP7-D23EIG5-QU25QS2-Y2KLCBT-NSLSG4A-UWDAU5X-54S4UAV";
      };
    };
  };

  security.rtkit.enable = true;

  location.provider = "geoclue2"; # For gammastep.

  environment = {
    pathsToLink = [ "/share/zsh" ];

    variables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
      EDITOR = "nvim"; # For SOPS.
    };
  };

  programs.zsh.enable = true;

  system = {
    stateVersion = "24.11"; # DO NOT TOUCH! Needed in case of backwards incompatible update.
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
