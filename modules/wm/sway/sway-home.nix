{
  config,
  pkgs,
  inputs,
  lib,
  hostType,
  ...
}:
{
  imports = [
    ../waybar/waybar.nix
    ./config/movement.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    # Already installed via bare nixos (for extraPackages), this is just for conf.
    package = null;

    config = {
      bars = [
        {
          command = "waybar";
          position = "top";

          mode = "hide";
          # modifier = "Mod4";
        }
      ];
      startup = [
        {
          command = "mako";
          always = true;
        }
        # {
        #   command = "copyq --start-server";
        #   always = true;
        # }
      ]
      ++ lib.optionals (hostType == "desktop") [
        # TODO: Fix this (bg not setting).
        {
          command = "swaymsg 'output DP-1 bg /etc/nixos/modules/wm/sway/backgrounds/desktop/busy-people/Top.png fill'";
          always = true;
        }
        {
          command = "swaymsg 'output HDMI-A-1 bg /etc/nixos/modules/wm/sway/backgrounds/desktop/busy-people/Bottom.png fill'";
          always = true;
        }
        {
          command = "swaymsg 'output DP-3 bg /etc/nixos/modules/wm/sway/backgrounds/desktop/busy-people/Right.png fill'";
          always = true;
        }
        { command = "wl-paste -t text --watch clipman store"; }
        { command = "wl-paste -p -t image --watch clipman store"; }

      ]
      ++ lib.optionals (hostType == "laptop") [
        {
          command = "swaymsg 'output eDP-1 bg /etc/nixos/modules/wm/sway/backgrounds/laptop/Waldo1.png fill'";
          always = true;
        }
      ];

      terminal = "alacritty";

      floating.titlebar = false;
      window = {
        titlebar = false;
        border = 0;
      };
    };

    extraConfig =
      ""
      + lib.optionalString (hostType == "desktop") ''
        ${builtins.readFile ./config/desktop/monitor.conf}
      ''
      + lib.optionalString (hostType == "laptop") ''
        ${builtins.readFile ./config/laptop/monitor.conf}
      '';

    extraSessionCommands = ''

    '';
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };

  services.gammastep = {
    enable = true;
    provider = "geoclue2";

    # TODO: Get this working. (https://discourse.nixos.org/t/sys-class-backlight-empty/57892)
    # settings = {
    #   general = {
    #     brightness-day = "0.5"; # Brightness as a string
    #     brightness-night = "0.5"; # Brightness as a string
    #   };
    # };

    dawnTime = "8:30-9:30";
    duskTime = "20:30-21:30";

    temperature = {
      day = 6500;
      night = 3700;
    };
  };

}
