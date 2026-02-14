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
    ../modules/docs/docs.nix
    ../modules/alacritty.nix
    ../modules/browser.nix

    ../modules/sway/sway-home.nix
    ../modules/wofi/wofi.nix
    ../modules/waybar/waybar.nix
  ];

  home = {
    username = "robert";
    homeDirectory = "/home/robert";
    stateVersion = "24.11"; # DO NOT TOUCH! Needed in case of backwards incompatible update.
  };

  home.packages = with pkgs; [
    # General
    blender
    jupyter
    # blender-hip  # GPU accel
    # teams
    brave
    loupe
    libreoffice-qt
    spotify
    # whatsapp-for-linux
    # wasistlos
    whatsie
    marimo
    # spotdl
    teams
    unigine-superposition
    gimp

    vlc

    bluetuith
    pavucontrol

    oterm
    code-cursor
    vscode
    devcontainer
    # atlauncher
    prismlauncher
    lutris

    # unstable.scummvm

    steam-run
    libtheora # This provides libtheoradec.so.1

    # You may also need these for ScummVM:
    alsa-lib
    pulseaudio
    SDL2
    zlib
    libpng
    libjpeg
    freetype

    p7zip

    space-cadet-pinball
    # lunar-client  # Minecraft

    # Support
    nurl
    nix-init
    # Misc

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # TODO: Partial configs in here for small tweaks like in nvim or waybar?

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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

  programs = {
    home-manager.enable = true; # DON'T TOUCH! Bootstrap.
    git.settings.user = {
      name = "RobertVDLeeuw";
      email = "robert.van.der.leeuw@gmail.com";
    };
  };
}
