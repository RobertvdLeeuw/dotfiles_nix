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
    ../../modules/ai/aitools.nix
    ../../modules/wm/sway/sway-home.nix
  ];

  home = {
    username = "robert";
    homeDirectory = "/home/robert";
    stateVersion = "24.11"; # DO NOT TOUCH! Needed in case of backwards incompatible update.

    file = {
      ".config/opencode" = {
        source = /etc/nixos/modules/ai;
        recursive = true;
      };
    };

  };

  programs = {
    home-manager.enable = true; # DON'T TOUCH! Bootstrap.
    git.settings.user = {
      name = "RobertVDLeeuw";
      email = "robert.van.der.leeuw@gmail.com";
    };
    ssh = {
      enable = true;

      matchBlocks = {
        "homelab" = {
          hostname = "192.168.2.111";
          port = 8022;
          user = "robert";
        };

        "rpi" = {
          hostname = "192.168.2.59";
          port = 22;
          user = "root";
        };
      };
    };

  };
}
