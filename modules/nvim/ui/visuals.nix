{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    theme = {
      enable = true;
      name = "oxocarbon";
      style = "dark";
    };

    visuals = {
      rainbow-delimiters = {
        enable = true;
        setupOpts = {
          highlight = [
            "RainbowDelimiterRed"
            "RainbowDelimiterYellow"
            "RainbowDelimiterBlue"
            "RainbowDelimiterOrange"
            "RainbowDelimiterGreen"
            "RainbowDelimiterViolet"
            "RainbowDelimiterCyan"
          ];
        };
      };
      cinnamon-nvim.enable = true;
      highlight-undo.enable = true;
      nvim-cursorline = {
        enable = true;
        setupOpts.cursorword.enable = true;
      };
    };

    ui = {
      borders = {
        enable = true;
        globalStyle = "single";
      };
      colorizer.enable = true;
      colorful-menu-nvim = {
        enable = true;
        setupOpts = { };
      };
    };

    # Autocmd to attach colorizer to relevant file types
    autocmds = [
      {
        event = [ "BufWinEnter" ];
        pattern = [
          "*.css"
          "*.scss"
          "*.sass"
          "*.less"
          "*.html"
          "*.htm"
          "*.js"
          "*.jsx"
          "*.ts"
          "*.tsx"
          "*.vue"
          "*.svelte"
          "*.conf"
          "*.config"
          "*.nix"
        ];
        command = "ColorizerAttachToBuffer";
        desc = "Auto-attach nvim-colorizer to color-relevant file types";
      }
    ];
  };
}
