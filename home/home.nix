{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../shells/zsh.nix

    # ../modules/nvim/nvim.nix
    ../modules/steam.nix
    ../modules/alacritty.nix
    ../modules/browser.nix

    ../modules/sway/sway-home.nix
    ../modules/wofi/wofi.nix
    ../modules/waybar/waybar.nix

    ../ai/aichat.nix
  ];

  home = {
    username = "robert";
    homeDirectory = "/home/robert";
    stateVersion = "24.11"; # DO NOT TOUCH! Needed in case of backwards incompatible update.
  };

  services.gammastep = {
    enable = true;
    provider = "geoclue2";

    # TODO: Get this working. (https://discourse.nixos.org/t/sys-class-backlight-empty/57892)
    # settings = {
    #   general = {
    #     brightness-day = "0.5"; # Brightness as a string
    #     brightness-night = "0.5"; # Brightness as a string
    #   };
    # };

    dawnTime = "8:30-9:30";
    duskTime = "20:30-21:30";

    temperature = {
      day = 6500;
      night = 3700;
    };
  };

  home.packages = with pkgs; [
    # General
    blender
    jupyter

    # teams
    brave
    loupe
    libreoffice-qt
    spotify
    whatsie
    # marimo
    teams
    gimp

    vlc

    bluetuith
    pavucontrol

    oterm
    opencode
    devcontainer

    prismlauncher
    lutris

    steam-run

    p7zip

    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    ".config/opencode" = {
      source = /etc/nixos/ai;
      recursive = true;
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/robert/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
  };

  programs = {
    home-manager.enable = true; # DON'T TOUCH! Bootstrap.
    git.settings.user = {
      name = "RobertVDLeeuw";
      email = "robert.van.der.leeuw@gmail.com";
    };
  };
}
