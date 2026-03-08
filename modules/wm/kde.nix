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
      elisa
      kate
      konsole
      gwenview
      okular
      ark
      spectacle
    ];
  };
}
