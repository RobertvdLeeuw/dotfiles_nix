{ config, pkgs, lib, inputs, ... }:
let
  user = "robert";

  config_dir = "/mnt/storage/nc/Personal/nixos";

  # workspaces = (builtins.getFlake "${config_dir}/modules/waybar/modules/workspaces").packages.x86_64-linux.default;

  # secrets = import ./secrets.nix;
in
  {
  imports = [
    ./hardware-configuration.nix
    ./modules/sway/sway.nix

    ./modules/prompt.nix

    ./modules/python.nix
    ./modules/rust.nix

    ./shells/bash.nix
  ];

  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [];

  networking = {
    # TODO: secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;

    nameservers = ["1.1.1.1" "8.8.8.8" ];
    # interfaces.eno1 = {
    #   useDHCP = false;
    #   ipv4.addresses = [{
    #     address = secrets.ip_address;
    #     prefixLength = 24;
    #   }];
    # };
  
    # defaultGateway = secrets.ip_gateway;
    # defaultGateway = [{
    #   address = secrets.ip_gateway;
    #   interface = "eno1";
    # }];
  };

  system = {
    stateVersion = "24.11";  # DO NOT TOUCH! Needed in case of backwards incompatible update.
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-VERSION";
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  fonts.packages = with pkgs; [
    iosevka
    fira-code
    fira-code-symbols
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

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

  location.provider = "geoclue2";  # For redshift.

  services = {
    printing.enable = true;  # CUPS
    redshift.enable = true;

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
      xkb = {  # Configure keymap in X11
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
      extraGroups = [ "networkmanager" "wheel" "docker" "video" ];  # Added video group for GPU access
    };
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      # nix-fast-build
      git-crypt
      surf

      dust
      zstd


      spicetify-cli
      time
      pciutils
      usbutils
      lm_sensors

      # Support  TODO: Recategorize.
      ffmpeg_6
      # foot
      # Package managers
      nodejs  # npm
      firefox

      # workspaces

      # To categorize
      git
      gcc
      ninja
      any-nix-shell  # for nix-shell in zsh. In don't like bash. No. Stop it.
    ];

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
      # GDK_BACKEND = "x11";  # For surf.
    };
  };

  programs = {
    zsh = {
      enable = true;
      interactiveShellInit = ''
        any-nix-shell zsh --info-right | source /dev/stdin
      '';
    };
  };
}
