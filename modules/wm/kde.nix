{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  services.desktopManager.plasma6.enable = true;
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      # https://github.com/NixOS/nixpkgs/blob/7e495b747b51f95ae15e74377c5ce1fe69c1765f/nixos/modules/services/desktop-managers/plasma6.nix#L150-L170
      elisa
      kate
      konsole
      gwenview
      okular
      ark
      spectacle
      ktexteditor
      baloo-widgets
      khelpcenter
    ];
  };
}
