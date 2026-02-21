{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    telescope = {
      enable = true;
      extensions = [
        {
          name = "fzf";
          packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
          setup.fzf.fuzzy = true;
        }
      ];

      mappings = {
        findFiles = "<C-f>";
        liveGrep = "<S-f>";
      };

      setupOpts = {
        defaults = {
          vimgrep_arguments = [
            "${pkgs.ripgrep}/bin/rg"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
          ];
          mappings = {
            i = lib.generators.mkLuaInline ''
              {["<esc>"] = require("telescope.actions").close,
               ["<A-j>"] = require("telescope.actions").move_selection_next,
               ["<A-k>"] = require("telescope.actions").move_selection_previous}
            '';
          };
        };
        pickers.find_files.find_command = [
          "${pkgs.ripgrep}/bin/rg"
          "--files"
          "--hidden"
        ];
      };
    };
  };
}
