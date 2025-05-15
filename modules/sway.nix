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

        rofi

        # Clipboard
        clipman
        grim
        wl-clipboard

        kdePackages.dolphin
      ];
    };
	};
  
}
