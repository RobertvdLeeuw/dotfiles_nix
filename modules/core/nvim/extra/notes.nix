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
        # convert.magick.imath = [
        #   "-density"
        #   192
        #   "{src}[{page}]"
        # ];
      };
    };

    luaConfigRC.snacks-inline-math = lib.nvim.dag.entryAfter [ "pluginConfigs" ] /* lua */ ''
      -- inline $...$ / \(...\): text-style math in a one-cell-high box, so every snippet gets the same scale
      local doc = Snacks.image.doc
      local orig = doc.transforms.latex
      local SHRINK = 1.0 -- >1 = smaller inline math, <1 = larger

      doc.transforms.latex = function(img, ctx)
      	local raw = vim.trim(img.content or "")
      	if not (img.ext == "math.tex" and (raw:find("^%$[^$]") or raw:find("^\\%("))) then
      		return orig(img, ctx)
      	end
      	local inner = raw:gsub("^\\%(", ""):gsub("\\%)$", ""):gsub("^%$", ""):gsub("%$$", "")
      	local t = Snacks.image.terminal.size()
      	-- strut height (pt) = one cell at natural size (css px = pt * 4/3 * scale)
      	local h = ((t.cell_height or 20) / (t.scale or 1)) * 0.75 * SHRINK
      	img.content = ("\\begin{math}\\rule[-%.2fpt]{0pt}{%.2fpt}%s\\end{math}"):format(0.28 * h, h, inner)
      	orig(img, ctx)
      	img.ext = "imath.tex" -- routes conversion to magick.imath (no -trim)
      end
    '';

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
