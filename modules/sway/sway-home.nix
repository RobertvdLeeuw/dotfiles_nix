{ config, pkgs, inputs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    # Already installed via conf (for extraPackages), this is jsut for conf.
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
        { command = "swaymsg 'output DP-1 bg /etc/nixos/modules/sway/backgrounds/busy-people/Bottom.png fill'
";
          always = true; }
        { command = "swaymsg 'output HDMI-A-1 bg /etc/nixos/modules/sway/backgrounds/busy-people/Top.png fill'
"; 
          always = true; }
        { command = "swaymsg 'output DP-3 bg /etc/nixos/modules/sway/backgrounds/busy-people/Right.png fill'"; 
          always = true; }
        # { command = ""; 
        #   always = true; }
      ];

      keybindings = {
        # TODO: Nixify these too?
      };

      terminal = "alacritty";

      floating.titlebar = false;
      window = {
        titlebar = false;
        border = 0;
      };
    };

    extraConfig = ''
      set $mod Mod4

      ${builtins.readFile ./config/media.conf}
      ${builtins.readFile ./config/monitor.conf}
      ${builtins.readFile ./config/controls.conf}
      ${builtins.readFile ./config/movement.conf}
    '';

    extraSessionCommands = ''

    '';
  };
}
