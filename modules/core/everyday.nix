{
  config,
  pkgs,
  lib,
  hostType,
  ...
}:
{
  home.packages =
    with pkgs;
    [
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
    ]
    ++ (lib.optionals (hostType == "laptop") [
      brightnessctl
    ]);
}
