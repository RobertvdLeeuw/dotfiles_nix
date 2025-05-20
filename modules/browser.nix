{ config, pkgs, lib, ... }:
{
  programs.qutebrowser = {
    enable = true;

    # Show tabs on Ctrl down
    # Ctrl+n tab nav

    # Split tab to new qute
    # Merge qute

    # Ctrl+space for search bar
    # Ctrl+h history
    # Figure out downloads

    # Bitwarden
    # Shazam


    extraConfig = ''

    '';
    # enableDefaultBindings = false;
    keyBindings = {  # Key -> logic
      normal = 
        # builtins.listToAttrs (map 
        #   (i: { name = "<Ctrl-${toString i}>"; value = "tab-focus ${toString i}"; }) 
        #   (lib.range 1 9)
        # ) //
        {
          # "<Ctrl>" = "set tabs show always";
          # "^<Ctrl>" = "set tabs show never";
          "<Ctrl-Space>" = "cmd-set-text -s :open ";
          "<Ctrl-h>" = "history";

          # "<C-a-h>" = "tab-prev";
          # "<C-a-l>" = "tab-next";
          # "<A-h>" = "back";
          # "<A-l>" = "forward";
          "F" = "hint all tab";
        };

      prompt = {
        "<Ctrl-y>" = "prompt-yes";
      };
    };
    keyMappings = {  # Key -> other key

    };

    # quickMarks = {  # Bookmarks

    # };

    searchEngines = {

    };

    settings =  # https://qutebrowser.org/doc/help/settings.html
      # Qutebrowser Catppuccin theme in Nix format
      # Palette
      let
        catppuccin = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };

        theme = catppuccin;
      in {
        colors = {
          completion = {
            category = {
              bg = "${theme.base}";
              border.bottom = "${theme.mantle}";
              border.top = "${theme.overlay2}";
              fg = "${theme.green}";
            };
            even.bg = "${theme.mantle}";
            odd.bg = "${theme.crust}";
            fg = "${theme.subtext0}";
            item.selected = {
              bg = "${theme.surface2}";
              border.bottom = "${theme.surface2}";
              border.top = "${theme.surface2}";
              fg = "${theme.text}";
              match.fg = "${theme.rosewater}";
            };
            match.fg = "${theme.text}";
            scrollbar = {
              bg = "${theme.crust}";
              fg = "${theme.surface2}";
            };
          };

          downloads = {
            bar.bg = "${theme.base}";
            error = {
              bg = "${theme.base}";
              fg = "${theme.red}";
            };
            start = {
              bg = "${theme.base}";
              fg = "${theme.blue}";
            };
            stop = {
              bg = "${theme.base}";
              fg = "${theme.green}";
            };
            system = {
              bg = "none";
              fg = "none";
            };
          };

          hints = {
            bg = "${theme.peach}";
            fg = "${theme.mantle}";
            match.fg = "${theme.subtext1}";
          };

          keyhint = {
            bg = "${theme.mantle}";
            fg = "${theme.text}";
            suffix.fg = "${theme.subtext1}";
          };

          messages = {
            error = {
              bg = "${theme.overlay0}";
              border = "${theme.mantle}";
              fg = "${theme.red}";
            };
            info = {
              bg = "${theme.overlay0}";
              border = "${theme.mantle}";
              fg = "${theme.text}";
            };
            warning = {
              bg = "${theme.overlay0}";
              border = "${theme.mantle}";
              fg = "${theme.peach}";
            };
          };

          prompts = {
            bg = "${theme.mantle}";
            border = "1px solid ${theme.overlay0}";
            fg = "${theme.text}";
            selected = {
              bg = "${theme.surface2}";
              fg = "${theme.rosewater}";
            };
          };

          statusbar = {
            normal = {
              bg = "${theme.base}";
              fg = "${theme.text}";
            };
            insert = {
              bg = "${theme.crust}";
              fg = "${theme.rosewater}";
            };
            command = {
              bg = "${theme.base}";
              fg = "${theme.text}";
            };
            caret = {
              bg = "${theme.base}";
              fg = "${theme.peach}";
              selection = {
                bg = "${theme.base}";
                fg = "${theme.peach}";
              };
            };
            progress.bg = "${theme.base}";
            passthrough = {
              bg = "${theme.base}";
              fg = "${theme.peach}";
            };
            private = {
              bg = "${theme.mantle}";
              fg = "${theme.subtext1}";
            };
            command.private = {
              bg = "${theme.base}";
              fg = "${theme.subtext1}";
            };
            url = {
              fg = "${theme.text}";
              error.fg = "${theme.red}";
              hover.fg = "${theme.sky}";
              success = {
                http.fg = "${theme.teal}";
                https.fg = "${theme.green}";
              };
              warn.fg = "${theme.yellow}";
            };
          };

          tabs = {
            bar.bg = "${theme.crust}";
            even = {
              bg = "${theme.surface2}";
              fg = "${theme.overlay2}";
            };
            odd = {
              bg = "${theme.surface1}";
              fg = "${theme.overlay2}";
            };
            indicator = {
              error = "${theme.red}";
              system = "none";
            };
            selected = {
              even = {
                bg = "${theme.base}";
                fg = "${theme.text}";
              };
              odd = {
                bg = "${theme.base}";
                fg = "${theme.text}";
              };
            };
          };

          contextmenu = {
            menu = {
              bg = "${theme.base}";
              fg = "${theme.text}";
            };
            disabled = {
              bg = "${theme.mantle}";
              fg = "${theme.overlay0}";
            };
            selected = {
              bg = "${theme.overlay0}";
              fg = "${theme.rosewater}";
            };
          };
        };

        # Border style for hints
        hints.border = "1px solid ${theme.mantle}";

        # statusbar.show = "never";
        tabs.show = "switching";


        # Optional: Add additional configuration options
        # This is based on the rest of the Python config, converted to Nix format
        # Uncomment if you want to include these settings

        # tabs.indicator.system = "none";
        # tabs.tabs_are_windows = false;
        # tabs.show = "always";
        # tabs.position = "top";
        # completion.show = "always";

        # You can add more qutebrowser settings here as needed
      };
  };
}
