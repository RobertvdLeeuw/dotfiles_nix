{ config, pkgs, inputs, ... }:

{
	imports = [
    ../shells/zsh.nix

		../modules/nvim/nvim.nix
    ../modules/steam.nix
    ../modules/alacritty.nix

		../modules/sway/sway-home.nix
		../modules/wofi/wofi.nix
		../modules/waybar/waybar.nix

    inputs.spicetify-nix.homeManagerModules.default
  ];

	home = {
		username = "robert";
		homeDirectory = "/home/robert";
		stateVersion = "24.11"; # DO NOT TOUCH! Needed in case of backwards incompatible update.
	};

  programs.spicetify =  # TODO: Move.
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

      spiceExtensionsRepo = pkgs.fetchFromGitHub {
        owner = "ohitstom";
        repo = "spicetify-extensions";
        rev = "cd00aa6e76da4f82f9a013f1363b2a45f92b0a0b";
        hash = "sha256-C59WBvq2fL+V/e8iUDBs77OSIPSku/FlHZ3xi4UWBBA=";
      };

      extraExtensions = {  # TODO: Fix these.
        oneko = {
          src = pkgs.fetchFromGitHub {
            owner = "kyrie25";
            repo = "spicetify-oneko";
            rev = "master"; 
            sha256 = "sha256-lestrf4sSwGbBqy+0J7u5IoU6xNKHh35IKZxt/phpNY=";
          };
          name = "oneko.js"; # Main file.
        };

        quickQueue = {
          name = "quickQueue.js";
          src = "${spiceExtensionsRepo}/quickQueue";
        };

        volumePercentage = {
          name = "volumePercentage.js";
          src = "${spiceExtensionsRepo}/volumePercentage";
        };
      };
    in
      {
      enable = true;
      theme = spicePkgs.themes.text;

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        keyboardShortcut
        trashbin
        powerBar
        autoVolume
        history
        extraExtensions.oneko
        extraExtensions.quickQueue
        extraExtensions.volumePercentage
      ];

      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        reddit
        marketplace
      ];
    };

	home.packages = with pkgs; [
		# General
		blender
    jupyter
    # blender-hip  # GPU accel
    # teams
		brave
		libreoffice-qt
		# spotify
		whatsapp-for-linux
    marimo
		spotdl
		unigine-superposition


		# Support
    nurl
    nix-init
		# Misc

		# # It is sometimes useful to fine-tune packages, for example, by applying
		# # overrides. You can do that directly here, just don't forget the
		# # parentheses. Maybe you want to install Nerd Fonts with a limited number of
		# # fonts?
		# (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

		# # You can also create simple shell scripts directly inside your
		# # configuration. For example, this adds a command 'my-hello' to your
		# # environment:
		# (pkgs.writeShellScriptBin "my-hello" ''
		#   echo "Hello, ${config.home.username}!"
		# '')
	];

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
		# # Building this configuration will create a copy of 'dotfiles/screenrc' in
		# # the Nix store. Activating the configuration will then make '~/.screenrc' a
		# # symlink to the Nix store copy.
		# ".screenrc".source = dotfiles/screenrc;

		# # You can also set the file content immediately.
		# ".gradle/gradle.properties".text = ''
		#   org.gradle.console=verbose
		#   org.gradle.daemon.idletimeout=3600000
		# '';
	};

	# Home Manager can also manage your environment variables through
	# 'home.sessionVariables'. These will be explicitly sourced when using a
	# shell provided by Home Manager. If you don't want to manage your shell
	# through Home Manager then you have to manually source 'hm-session-vars.sh'
	# located at either
	#
	#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#  /etc/profiles/per-user/robert/etc/profile.d/hm-session-vars.sh
	#

	programs = {
    home-manager.enable = true;  # DON'T TOUCH! Bootstrap.
    git = {
      userName = "RobertVDLeeuw";
      userEmail = "robert.van.der.leeuw@gmail.com";
    };
  };
}
