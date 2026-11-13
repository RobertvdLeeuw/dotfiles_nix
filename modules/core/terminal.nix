{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  programs = {
    kitty = {
      enable = config.my.GUI && !config.my.sudoTools;

      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12;
      };

      settings = {
        background = "#0d0d16";
        foreground = "#c9c7cd";
        cursor = "#ccdbe0";
        cursor_text_color = "#0d0f18";

        color0 = "#282828";
        color1 = "#ca1444";
        color2 = "#90b99f";
        color3 = "#e8a831";
        color4 = "#b9aeda";
        color5 = "#cb6fa1";
        color6 = "#aca1cf";
        color7 = "#ccdbe0";

        background_opacity = "0.97";
        window_padding_width = 0;
        enable_audio_bell = false;
      };

      shellIntegration.mode = "no-cursor";
    };

    starship = {
      enable = true;

      # TODO: Figure out why these don't work.
      # enableBashIntegration = true;
      # enableZshIntegration = true;

      # Hardcoded colors (HEX) so nvim theme doesn't remap colors and fuck up the looks.
      settings = {
        format = "┌$username$directory$git_branch$nix_shell$shell\n$character";
        line_break = true;
        add_newline = false;

        character = {
          success_symbol = "└─";
          error_symbol = "└─";
          vimcmd_symbol = "└─";
        };

        username = {
          style_user = "bold #90b99f";
          style_root = "bold #ca1444";
          format = "──\\[[$user]($style)\\]";
          show_always = false;
          disabled = false;
        };

        directory = {
          format = "──\\[[$path](bold #cb6fa1)\\]";
          truncation_length = 4;
          truncate_to_repo = false;
          truncation_symbol = "…/";
        };

        git_branch = {
          format = "──\\[[$branch](bold #aca1cf)\\]";
        };

        nix_shell = {
          format = "──\\[[nix](bold #90b99f)\\]";
        };

        shell = {
          bash_indicator = "──\\[[bash](bold #e8a831)\\]";
          zsh_indicator = "";
          disabled = false;
          format = "$indicator";
        };
      };
    };
  };

  home.packages = with pkgs; [
    bat
    dust
    fd
    fzf
    # pick
    tree
    zoxide
  ];
}
