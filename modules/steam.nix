{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    steam
    steamtinkerlaunch
    gamescope
  ];

	# programs.steam.enable = true;
  # environment = {
    # systemPackages = with pkgs; [
      # MO2 somehow, change this to gaming.nix

      # wineWowPackages.stable
      # winetricks
      # protontricks
      # mesa
    # ];
  # };
}
