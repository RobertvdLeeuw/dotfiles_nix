{ config, pkgs, inputs, ... }:
let 
  base_config = {
    height = 30;
    spacing = 4; # Gaps between modules (4px)
    modules-left = [ "clock" "pulseaudio" "bluetooth" ];
    modules-center = ["custom/workspaces"];
    modules-right = [
      "cpu"
      "memory"
      "temperature"
    ];
    clock = {
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format = "󰃰 {:%H:%M  <b>%d %b</b>}";
      tooltip = false;
    };

    pulseaudio = {
      scroll-step = 5; # %; can be a float
      format-muted = "󰓃 󰖁";
      format = "󰓃 {volume}%";
      format-source = "󰓃";
      format-icons = {
        headphone = "󰋋";
        hands-free = "󰓃";
        headset = "󰋋";
        phone = "󰓃";
        portable = "󰓃";
        car = "󰓃";
        default = ["󰕿" "󰖀" "󰕾"];
      };
      on-click = "pavucontrol";
      on-click-right = "pavucontrol";
      tooltip = false;
    };
    bluetooth = {
      format = "󰂯";
      format-off = "󰂲";
      format-connected = "{count} 󰂰";
      tooltip = false;
    };

    cpu = {
      format = "{usage}% 󰒪";
      tooltip = false;
    };
    memory = {
      format = "{}% 󰆼";
      tooltip = false;
    };
  };

  screens = map (screen: screen // 
    {"custom/workspaces" = {
      exec = "cd /etc/nixos/modules/waybar/modules/workspaces; nix run .# -- ${screen.output}";
      return-type = "json";
      format = "{}";
      tooltip = false;
      escape = false;
    };} // (if screen.bar_id != "3" then {  # Horizontal only
      network = {
        format-wifi = "{essid} ({signalStrength}%) 󰤨 ";
        format-ethernet = " 󰌘";
        format-linked = "{ifname} (No IP) 󰤩 ";
        format-disconnected = "󰌙";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        tooltip = false;
      };
      cpu = {
        format = "{usage}% 󰒪";
        tooltip = false;
      };
      memory = {
        format = "{}% 󰆼";
        tooltip = false;
      };
      modules-right = [
        "network"
        "cpu"
        "memory"
        "temperature"
      ];
    } else {  # Vertical only
    })) 
    [
      { bar_id = "1"; ipc = true; output = "DP-1"; }  # UW
      { bar_id = "2"; ipc = true; output = "HDMI-A-1"; }  # Top
      { bar_id = "3"; output = "DP-3"; }  # Ver
    ];

  configs = map (extra: base_config // extra) screens;
in
{
  programs.waybar = {
    enable = true;

    settings = configs;
    style = ./style.css;
  };
}
