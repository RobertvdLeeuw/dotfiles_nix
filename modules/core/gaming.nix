{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    steam

    # For MO2 modding
    steamtinkerlaunch
    steam-run

    gamescope
    prismlauncher # Minecraft
  ];
}
