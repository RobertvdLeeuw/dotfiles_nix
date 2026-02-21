{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    autocomplete.blink-cmp = {
      enable = true;

      mappings = {
        confirm = "<Tab>";

        next = "<A-j>";
        previous = "<A-k>";

        scrollDocsDown = "<C-j>";
        scrollDocsUp = "<C-k>";
      };

      setupOpts = {
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
          per_filetype.codecompanion = [ "codecompanion" ];
        };

        completion = {
          menu = {
            min_width = 15;
            max_height = 10;

            draw = {
              columns = [
                [ "kind_icon" ]
                [ "label" ]
              ];

              components = {
                kind_icon = {
                  highlight = lib.generators.mkLuaInline ''
                    function(ctx)
                      return require("colorful-menu").blink_components_highlight(ctx)
                    end
                  '';
                };

                label = {
                  text = lib.generators.mkLuaInline ''
                    function(ctx)
                      return require("colorful-menu").blink_components_text(ctx)
                    end
                  '';
                  highlight = lib.generators.mkLuaInline ''
                    function(ctx)
                      return require("colorful-menu").blink_components_highlight(ctx)
                    end
                  '';
                };
              };
            };
          };

          documentation = {
            window = {
              min_width = 10;
              max_width = 80;
              max_height = 20;

              desired_min_width = 50;
              desired_min_height = 10;

              border = "single";

              direction_priority = {
                menu_north = [
                  "e"
                  "s"
                  "n"
                ];
                menu_south = [
                  "e"
                  "s"
                  "n"
                ];
              };
            };
            auto_show_delay_ms = 200;
          };
        };

        keymap = {
          "<A-Tab>" = [
            "snippet_forward"
            "fallback"
          ];
          "<A-S-Tab>" = [
            "snippet_backward"
            "fallback"
          ];
        };

        cmdline = {
          completion.menu.auto_show = true;
          keymap.preset = "inherit";
        };
      };
      friendly-snippets.enable = true;
    };

    snippets.luasnip.enable = true;
  };
}
