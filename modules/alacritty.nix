{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # environment = {
    # systemPackages = with pkgs; [
    alacritty  # TODO: Clear screen before command if shift + enter.

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
