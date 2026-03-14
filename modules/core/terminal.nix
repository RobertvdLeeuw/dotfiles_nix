{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  programs = {
    alacritty = {
      enable = !config.my.noGUI;

      settings = {
        colors = {
          cursor = {
            background = "#ccdbe0";
            foreground = "#0d0f18";
          };
          normal = {
            black = "#282828";
            blue = "#b9aeda";
            cyan = "#aca1cf";
            green = "#90b99f";
            magenta = "#cb6fa1";
            red = "#ca1444";
            white = "#ccdbe0";
            yellow = "#e8a831";
          };
          primary = {
            background = "#0d0d16";
            foreground = "#c9c7cd";
          };

          vi_mode_cursor = {
            background = "#161617";
            foreground = "#c9c7cd";
          };
        };

        font = {
          size = 12;

          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };

          bold_italic = {
            family = "JetBrainsMono Nerd Font";
            style = "BoldItalic";
          };

          glyph_offset = {
            x = 0;
            y = 0;
          };

          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };

          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };

          offset = {
            x = 0;
            y = 0;
          };
        };

        window = {
          opacity = 0.97;

          padding = {
            x = 0;
            y = 0;
          };
        };
      };
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
