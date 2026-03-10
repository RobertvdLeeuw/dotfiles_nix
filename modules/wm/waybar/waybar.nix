{
  config,
  pkgs,
  inputs,
  hostType,
  ...
}:

let
  inherit (inputs.waybar-modules.packages.x86_64-linux) workspaces resources diagnostics;

  base_config = {
    height = 30;
    spacing = 4; # Gaps between modules (4px)
    modules-left = [
      "clock"
      "pulseaudio"
    ];
    modules-center = [ "custom/workspaces" ];
    modules-right = [ ];
    clock = {
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format = "󰃰 {:%H:%M  <b>%d %b</b>}";
      tooltip = false;
    };

    pulseaudio = {
      scroll-step = 5; # %; can be a float
      format-muted = "{icon} 󰖁";
      format = "{icon} {volume}%";
      format-source = "󰓃";
      format-icons = {
        headphone = "󰋋";
        headset = "󰋋";
        speaker = "󰓃";
        default = [
          "󰓃"
        ];
      };
      on-click = "/etc/nixos/modules/wm/waybar/swap_audio_output.sh";
      on-click-right = "pavucontrol";
      tooltip = false;
    };

    "custom/cpu_info" = {
      exec = "${resources}/bin/resources CPU";
      return-type = "json";
      format = "{}";
      tooltip = false;
      escape = false;
    };
  };

  screens =
    map
      (
        screen:
        screen
        // {
          "custom/workspaces" = {
            exec = "${workspaces}/bin/workspaces ${screen.output}";
            return-type = "json";
            format = "{}";
            tooltip = false;
            escape = false;
          };
        }
        // (
          if screen.bar_id != "3" then
            {
              "custom/gpu_info" = {
                exec = "${resources}/bin/resources GPU";
                return-type = "json";
                format = "{}";
                tooltip = false;
                escape = false;
              };
              modules-right = [
                "custom/cpu_info"
                "custom/gpu_info"
              ];
            }
          else
            {
              # Vertical only
              "custom/diagnostics" = {
                exec = "${diagnostics}/bin/diagnostics desktop";
                return-type = "json";
                format = "{}";
                tooltip = false;
                escape = false;
              };
              modules-right = [
                "custom/diagnostics"
              ];
            }
        )
      )
      [
        {
          bar_id = "1";
          ipc = true;
          output = "DP-1";
        } # UW
        {
          bar_id = "2";
          ipc = true;
          output = "HDMI-A-1";
        } # Top
        {
          bar_id = "3";
          output = "DP-3";
        } # Ver
      ];

  configs =
    if hostType == "desktop" then
      map (extra: base_config // extra) screens
    else
      [
        (
          base_config
          // {
            ipc = true;
            output = "eDP-1";

            "custom/workspaces" = {
              exec = "${workspaces}/bin/workspaces eDP-1";
              return-type = "json";
              format = "{}";
              tooltip = false;
              escape = false;
            };

            "custom/diagnostics" = {
              exec = "${diagnostics}/bin/diagnostics laptop";
              return-type = "json";
              format = "{}";
              tooltip = false;
              escape = false;
            };

            "battery" = {
              format = "{icon} {capacity}%";
              states = {
                critical = 15;
                low = 30;
                good = 80;
                full = 100;
              };
              format-icons = {
                critical = "󰂃";
                low = "󰁼";
                good = "󰂀";
                full = "󰁹";
                charging = "󰂄";
              };
            };
            modules-right = [
              "custom/diagnostics"
              "custom/cpu_info"
              "battery"
            ];
          }
        )
      ];
in
{
  programs = {
    waybar = {
      enable = true;

      settings = configs;
      style =
        builtins.replaceStrings
          [ "font-size: 15px" ]
          [ "font-size: ${if hostType == "desktop" then "15" else "16"}px" ]
          (builtins.readFile ./style.css);
    };
    # TODO: Implement EWW.
    # eww = {
    #   enable = true;
    #   enableZshIntegration = true;
    #
    #   configDir = ./modules/eww;
    # };
  };
}
