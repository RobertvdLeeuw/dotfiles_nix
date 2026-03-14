{
  config,
  pkgs,
  pkgs-ollama,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/core
    ../../modules/wm/sway/sway-home.nix
  ];

  my.noAI = true;

  home = {
    username = "robert";
    homeDirectory = "/home/robert";
    stateVersion = "24.11"; # DO NOT TOUCH! Needed in case of backwards incompatible update.
  };

  programs = {
    home-manager.enable = true; # DON'T TOUCH! Bootstrap.
    git.settings.user = {
      name = "RobertVDLeeuw";
      email = "robert.van.der.leeuw@gmail.com";
    };
  };
}
