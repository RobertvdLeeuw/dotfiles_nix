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
    <home-manager/nixos>
  ];

  home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		users.${user} = import /home/${user}/.config/home-manager/home.nix;
		users.root = import /home/${user}/.config/home-manager/home-root.nix;
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

  # ROCm configuration - updated approach
  nixpkgs.config = {
    allowUnfree = true;
    rocmSupport = true;
  };

  # Install ROCm as a hardware module instead of manually symlinked packages
  hardware.opengl.extraPackages = with pkgs.rocmPackages; [
    clr
    hipblas
    hipcub
    hipfft
    hipsolver
    hipsparse
    miopen
    rocm-smi
    rccl
    rocblas
    rocthrust
  ];

  # Create a compatibility symlink for tools that expect ROCm in /opt/rocm
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm   -    -    -     -    ${pkgs.rocmPackages.rocminfo}"
  ];

  # Adding the HIP compiler
  environment.variables = {
    "HIP_PATH" = "${pkgs.rocmPackages.clr}";
    "HSA_PATH" = "${pkgs.rocmPackages.rocm-runtime}";
  };

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
		displayManager = {
      autoLogin = {
        enable = true;
        user = "robert";
      };
			sddm.enable = true;
			defaultSession = "sway";
		};
		desktopManager.plasma6.enable = true;

    xserver = {
      enable = true;
      xkb = {  # Configure keymap in X11
        layout = "us";
        variant = "";
      };
    };
    printing.enable = true;  # CUPS
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
	};

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.robert = {
      isNormalUser = true;
      description = "robert";
      extraGroups = [ "networkmanager" "wheel" "docker" "video" ];  # Added video group for GPU access
    };
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      # Base
      zsh
      zplug
      # neovim
      alacritty  # TODO: Clear before command if shift + enter.

      # WM/DE
      sway
      waybar

      # Support  TODO: Recategorize.
      libnotify
      docker
      ffmpeg_6
      wineWowPackages.stable
      winetricks
      wget
      protontricks
      mesa
      jq
      wev
      which
      pciutils

      # Terminal stuff
      neofetch
      bat
      fd
      fzf
      killall
      lutris

      gettext
      tealdeer
      tree
      unzip
      zip
      zoxide

      # Clipboard
      clipman
      grim
      wl-clipboard

      # Package managers
      cargo
      nodejs  # npm

      # Languages
      rustc
      python313

      # To categorize
      git
      gcc
      ninja

      rocmPackages.clr
      rocmPackages.hipblas
      rocmPackages.hipcub
      rocmPackages.hipfft
      rocmPackages.hipsolver
      rocmPackages.hipsparse
      rocmPackages.miopen
      rocmPackages.rocm-smi
      rocmPackages.rccl
      rocmPackages.rocblas
      rocmPackages.rocthrust
    ];
  };

  virtualisation = {
    waydroid.enable = true;
    docker.enable = true;
  };

	programs = {
    steam.enable = true;
    zsh = {
      enable = true;
        shellAliases = {
          rebuild = "nixos-rebuild build --use-remote-sudo";
          update = "nixos-rebuild switch --use-remote-sudo";

          cnfnix = "cd /etc/nixos && sudo nvim configuration.nix && cd -";
          cnfhome = "cd /mnt/storage/nc/Personal/dotfiles/home-manager && nvim home.nix && cd -";
          cnfvim = "cd /mnt/storage/nc/Personal/dotfiles/home-manager && nvim nvim/nvim.nix && cd -";

          dv = "find ./src/ && fd --type f --exclude __pycache__ | fzf -q src/ | xargs -r nvim";
          nsh = ''
if [ ! -f \"shell.nix\" ]; then
  echo \"{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  packages = with pkgs.python312Packages; [
  ];
}\" > shell.nix
fi

nvim shell.nix
		'';

        todo = "nvim ~/Documents/todo.md";
        books = "nvim ~/Documents/books.txt";
	    };
	    shellInit = ''
	eval "$(zoxide init --cmd cd zsh)"
	eval "$(fzf --zsh)"

	  # Autocomplete
	autoload -U compinit
	zmodload zsh/complist
	compinit
	_comp_options+=(globdots)             # Include hidden files.

	zstyle ':completion:*' matcher-list 'm:{a-z}={a-zA-Z}'
	zstyle ':completion:*' list-colors '{(s.:.)LS_COLORS}'
	zstyle ':completion:*' menu no

	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

	bindkey '^I'   complete-word       # tab
	bindkey '^[[Z' autosuggest-accept  # shift + tab

  clear-terminal() { tput reset; zle redisplay; }
  zle -N clear-terminal
  bindkey '^[l' clear-terminal
  bindkey -M viins '^[l' clear-terminal


  # bindkey '^[[1;5A' history-search-backward
  # bindkey '^[[1;5B' history-search-forward

	bindkey '^[k' history-search-backward
	bindkey '^[j' history-search-forward
  bindkey -M viins '^[k' history-search-backward
  bindkey -M viins '^[j' history-search-forward

  '';
	  promptInit = ''
	autoload -Uz vcs_info
	precmd() { vcs_info }

	precmd() {
		vcs_info
		# Print a newline before the prompt, but only if it's not the first prompt
		if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
			NEW_LINE_BEFORE_PROMPT=1
		elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
			echo ""
		fi
	}

	# Configure vcs_info for git
	zstyle ':vcs_info:git:*' check-for-changes true
	zstyle ':vcs_info:git:*' stagedstr '%F{green}'
	zstyle ':vcs_info:git:*' unstagedstr '%F{red}'
	zstyle ':vcs_info:git:*' formats '──[%B%%F{cyan}%b%u%c%%F{cyan}%%f]'

	# Function to detect virtual environments
	function virtualenv_info {
		if [[ -n $VIRTUAL_ENV ]]; then
			echo "──[%F{yellow}%B$(basename $VIRTUAL_ENV)%b%f]"
		else
			echo ""
		fi
	}

	# Colors for username and current directory - easily customizable
	USERNAME_COLOR="green"
	DIRECTORY_COLOR="magenta"


	function username_info {
		if [[ "$USER" != "robert" ]]; then
			echo "[%B%F{$USERNAME_COLOR}%n%f%b]──"
		else
			echo ""
		fi
	}


	# Set the prompt  TODO: GIT STATUS
	setopt PROMPT_SUBST
	PROMPT='┌──$(username_info)[%B%F{$DIRECTORY_COLOR}%~%f%b]$(virtualenv_info)
└─ '
	export VIRTUAL_ENV_DISABLE_PROMPT=1
      '';
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
	};
}
