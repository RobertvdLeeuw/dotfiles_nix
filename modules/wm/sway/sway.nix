{ config, pkgs, ... }:

{
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        # Notification daemon
        # libnotify  # X11
        mako # Wayland

        playerctl
        pulseaudio # For pactl

        # Clipboard
        wl-clipboard
        clipman
        cliphist

        # Screenshots
        grim
        slurp
      ];
    };
  };

}
