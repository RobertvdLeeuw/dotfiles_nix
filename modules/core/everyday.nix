{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    brave

    # Dolphin is installed auto via KDE

    libreoffice-qt
    pavucontrol

    spotify

    whatsie
    discord
    teams

    loupe # Image viewer
    gimp
    vlc
  ];
}
