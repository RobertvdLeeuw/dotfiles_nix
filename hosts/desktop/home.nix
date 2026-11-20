{
  config,
  pkgs,
  pkgs-ollama,
  inputs,
  ...
}:

let
  facts = import ../facts.nix;
in
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

      settings = {
        "homelab" = {
          hostname = facts.hosts.server.name;
          port = facts.hosts.server.ssh-port;
          user = "robert";
        };

        "rpi" = {
          hostname = facts.hosts.rpi.name;
          port = facts.hosts.rpi.ssh-port;
          user = "robert";
        };
      };
    };
  };
}
