{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    notes.obsidian = {
      enable = false;
      setupOpts = { };
    };

    # mermaid ($ mmdc) + $$...$$ + inline $...$ all rendered as images via the kitty protocol.
    utility.snacks-nvim = {
      enable = true;
      setupOpts.image = {
        enabled = true;
        doc = {
          enabled = true;
          inline = true;
          float = false;
          max_width = 80;
          max_height = 40;

          # hide source for math and mermaid ("chart" is marked experimental upstream)
          conceal = lib.generators.mkLuaInline /* lua */ ''
            function(_, type)
              return type == "math" or type == "chart"
            end
          '';
        };
        math = {
          enabled = true;
          latex = {
            font_size = "normalsize";
            packages = [
              "amsmath"
              "amssymb"
              "amsfonts"
              "mathtools"
            ];
          };
        };
        convert = {
          mermaid = lib.generators.mkLuaInline /* lua */ ''
            function()
              return { "-i", "{src}",
                       "-o", "{file}",
                       "-b", "transparent",
                       "-t", "redux-dark-color",
                       "-s", "{scale}" }
            end
          '';
        };
      };
    };

    # render-markdown keeps doing plain markdown, but must not touch math anymore.
    # (option path inferred from nvf conventions - check with nvf-print-config)
    languages.markdown.extensions.render-markdown-nvim.setupOpts.latex.enabled = false;

    extraPackages = with pkgs; [
      imagemagick
      ghostscript
      tectonic
      mermaid-cli
    ];
  };
}
