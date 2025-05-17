{ config, pkgs, ... }:

{
	programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        # Notification daemon  TODO: Don't I just need 1, not both?
        libnotify
        mako  

        waybar

        playerctl

        wofi

        # Clipboard
        wl-clipboard
        copyq  # History

        # Screenshots
        grim
        slurp

        # kdePackages.dolphin
      ];
    };
	};
  
}
