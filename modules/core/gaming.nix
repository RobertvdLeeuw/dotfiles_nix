{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf (!config.my.noGUI && !config.my.sudoTools) {
    home.packages = with pkgs; [
      steam

      # For MO2 modding
      steamtinkerlaunch
      steam-run

      gamescope
      prismlauncher # Minecraft
    ];
  };
}
