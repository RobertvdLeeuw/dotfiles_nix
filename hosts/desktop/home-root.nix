{ config, pkgs, ... }:

{
  imports = [
    ../../modules/core/shells
    ../../modules/core/system-tools.nix
  ];

  home = {
    username = "root";
    stateVersion = "24.11"; # DO NOT TOUCH! Needed in case of backwards incompatible update.
  };

  programs.home-manager.enable = true;
}
