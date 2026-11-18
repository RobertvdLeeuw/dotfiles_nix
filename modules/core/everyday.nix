{
  config,
  pkgs,
  lib,
  hostType,
  inputs,
  ...
}:
{
  # imports = [ inputs.zen-browser.homeModules.twilight ];

  config = lib.mkIf (config.my.GUI && !config.my.sudoTools) {
    home.packages =
      with pkgs;
      [
        brave
        thunar

        libreoffice-fresh
        pavucontrol

        blender
        spotify
        blender

        discord
        teams

        loupe # Image viewer
        pinta # Linux equiv of paint.net
        gimp
        vlc
      ]
      ++ (lib.optionals (hostType == "desktop") [
        openrgb
      ])
      ++ (lib.optionals (hostType == "laptop") [
        # TODO: Move to options in default.nix
        brightnessctl
        bluez

        fwupd
        innoextract
      ]);
  };
}
