{
  config,
  pkgs,
  inputs,
  lib,
  hostType,
  ...
}:
let
  mod = "Mod4"; # Windows key

  get_workspace =
    if hostType == "desktop" then
      "/etc/nixos/modules/wm/sway/scripts/desktop/get_workspace.sh"
    else
      "/etc/nixos/modules/wm/sway/scripts/laptop/get_workspace.sh";

  navKeys = [
    {
      arrowKey = "Left";
      vimKey = "h";
      dir = "left";
    }
    {
      arrowKey = "Down";
      vimKey = "j";
      dir = "down";
    }
    {
      arrowKey = "Up";
      vimKey = "k";
      dir = "up";
    }
    {
      arrowKey = "Right";
      vimKey = "l";
      dir = "right";
    }
  ];
in
{
  wayland.windowManager.sway = {
    config = {
      modifier = mod;

      modes = {
        resize = {
          "${mod}+r" = "mode default";
          "h" = "resize shrink width 10 px";
          "j" = "resize grow height 10 px";
          "k" = "resize shrink height 10 px";
          "l" = "resize grow width 10 px";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };

      keybindings = lib.mkMerge (
        # Nav workspaces 1-4
        (map (n: {
          "${mod}+${toString n}" = "exec swaymsg workspace number $(${get_workspace} ${toString n})";
          "${mod}+Shift+${toString n}" =
            "swaymsg move container to workspace number $(${get_workspace} ${toString n}) && swaymsg workspace number $(${get_workspace} ${toString n})";
        }) (lib.range 1 4))
        # Nav containers hjkl+arrows
        ++ (map (binding: {
          "${mod}+${binding.arrowKey}" = "focus ${binding.dir}";
          "${mod}+Shift+${binding.arrowKey}" = "move ${binding.dir}";
          "${mod}+${binding.vimKey}" = "focus ${binding.dir}";
          "${mod}+Shift+${binding.vimKey}" = "move ${binding.dir}";
        }) navKeys)
        ++ [
          {
            "${mod}+Shift+w" = "kill";
            "${mod}+Shift+c" = "reload";
            "${mod}+b" = "exec brave --password-store=basic";
            "${mod}+s" = "exec spofity";
            "${mod}+e" = "exec dolphin";
            "${mod}+Return" = "exec alacritty";
            "${mod}+space" = "exec wofi run --show drun";

            "${mod}+r" = "mode resize";

            "${mod}+Shift+e" =
              "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

            "${mod}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy"; # Area screenshot
            "${mod}+v" = "exec clipman pick -t wofi";
          }
          (lib.optionalAttrs (hostType == "desktop") {
            # Volume controls
            "XF86AudioRaiseVolume" = "exec /etc/nixos/modules/wm/sway/scripts/volume_clamp.sh";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";

            # Media playback controls
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioStop" = "exec playerctl stop";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";
          })
        ]
      );
    };
  };
}
