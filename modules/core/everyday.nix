{
  config,
  pkgs,
  lib,
  hostType,
  ...
}:
{
  config = lib.mkIf (!config.my.noGUI && !config.my.sudoTools) {
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
        # TODO: Move to options in default.nix
        brightnessctl
        bluez
      ]);
  };
}
