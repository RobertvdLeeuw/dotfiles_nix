{ config, pkgs, inputs, ... }:

{
    environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      alacritty  # TODO: Clear before command if shift + enter.

      # Support  TODO: Recategorize.
      wget
      jq
      # wev
      which

      # Terminal stuff
      neofetch
      # bat
      fd
      fzf
      # killall
      lutris

      gettext
      # tealdeer
      tree
      unzip
      zip
      zoxide

      git
      gcc
      ninja
    ];
}
