# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:
let
  user = "robert";
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/sway.nix

    ./modules/prompt.nix

    # ../shells/zsh/zsh.nix

    <home-manager/nixos>
  ];

  home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;

		users.${user} = import ./home/home.nix;
		users.root = import ./home/home-root.nix;
	};

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
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

	services = {
    printing.enable = true;  # CUPS

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

  security.rtkit.enable = true;

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
      # WM/DE
      sway
      waybar

      # Support  TODO: Recategorize.
      ffmpeg_6

      # Package managers
      nodejs  # npm

      # To categorize
      git
      gcc
      ninja
    ];

    variables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };
  };

	programs = {
    zsh.enable = true;
	};
}
