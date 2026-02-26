{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    terminal = {
      toggleterm = {
        enable = true;
        mappings.open = "<C-Space>";
        setupOpts = {
          direction = "horizontal";
          size = lib.generators.mkLuaInline "function(term) return (10 + vim.o.lines / 4) end";

          winbar.enabled = false;

          # on_close = lib.generators.mkLuaInline /* lua */ ''
          #   function(term)
          #     if vim.t.codecompanion_maximized and vim.t.codecompanion_maximized_win then
          #       vim.api.nvim_set_current_win(vim.t.codecompanion_maximized_win)
          #       vim.cmd("resize")
          #       vim.cmd("vertical resize")
          #     end
          #   end
          # '';

          shell = lib.generators.mkLuaInline /* lua */ ''
            function()
              if vim.g.devcontainer_running then
                local cli = require("devcontainers.cli")
                local manager = require("devcontainers.manager")

                return "cd " .. manager.find_workspace_dir() .. "; devcontainer exec /bin/zsh"
              end

              return vim.o.shell
            end
          '';
        };
      };
    };
  };
}
