{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf (config.my.GUI && !config.my.sudoTools) {
    home.packages = with pkgs; [
      steam
      lutris

      # For MO2 modding
      steamtinkerlaunch
      steam-run

      gamescope
      prismlauncher # Minecraft
    ];
  };
}
