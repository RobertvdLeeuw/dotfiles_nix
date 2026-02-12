{ config, pkgs, ... }:

{
	imports = [
    ../shells/zsh.nix

		# ../modules/nvim/nvim.nix
	];

	home = {
		username = "root";
		stateVersion = "24.11"; # DO NOT TOUCH! Needed in case of backwards incompatible update.
	};

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
