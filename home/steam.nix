{ config, pkgs, ... }:

{
  environment = {
    # pathsToLink = [ "" ];
    systemPackages = with pkgs; [
      steam

      # MO2 somehow, change this to gaming.nix

      # wineWowPackages.stable
      # winetricks
      # protontricks
      # mesa
  };
}
