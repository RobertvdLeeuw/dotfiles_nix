{ config, pkgs, inputs, ... }:
let 
  base_config = {
    height = 30;
    spacing = 4; # Gaps between modules (4px)
    modules-left = ["clock" "pulseaudio" "bluetooth" "sway/scratchpad"];
    modules-center = ["custom/workspaces"];
    "modules-right" = [
      "network"
      "cpu"
      "memory"
      "temperature"
      "custom/power"
    ];
    "custom/workspaces" = {
      # exec = "$HOME/.config/waybar/waybar_modules/workspaces DP-1";
      # exec = "cd /etc/nixos/modules/waybar/modules/workspaces; nix run .# -- ${output}";
      return-type = "json";
      format = "{}";
      tooltip = false;
      escape = false;
    };
    "bluetooth" = {
      format = "󰂯";
      format-off = "󰂲";
      format-connected = "{count} 󰂰";
      tooltip = false;
    };
    "clock" = {
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format = "󰃰 {:%H:%M  <b>%d %b</b>}";
      tooltip = false;
    };
    "cpu" = {
      format = "{usage}% 󰒪";
      tooltip = false;
    };
    "memory" = {
      format = "{}% 󰆼";
      tooltip = false;
    };
    "network" = {
      format-wifi = "{essid} ({signalStrength}%) 󰤨 ";
      format-ethernet = " 󰌘";
      format-linked = "{ifname} (No IP) 󰤩 ";
      format-disconnected = "󰌙";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
      tooltip = false;
    };
    "pulseaudio" = {
      scroll-step = 5; # %; can be a float
      format-muted = "󰓃  󰖁 ";
      format = "󰓃 {volume}% 󰕾";
      format-source = "󰓃";
      "format-icons" = {
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
    "custom/power" = {
      format = "󰤆";
      menu = "on-click";
      menu-file = "/etc/nixos/modules/waybar/modules/power_menu.xml"; # Menu file in resources folder
      "menu-actions" = {
        shutdown = "shutdown";
        reboot = "reboot";
        suspend = "systemctl suspend";
        hibernate = "systemctl hibernate";
      };
      tooltip = false;
    };
  };

  screens = map (screen: screen // 
    {"custom/workspaces" = {
      # exec = "cd /etc/nixos/modules/waybar/modules/workspaces; nix run .# -- ${screen.output}";
      # return-type = "json";
      # format = "{}";
      # tooltip = false;
      # escape = false;
    };}) 
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
