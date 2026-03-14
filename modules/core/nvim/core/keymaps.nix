{
  pkgs,
  lib,
  config,
  ...
}:
{
  settings.vim = {
    keymaps = [
      # LSP navigation via glance
      {
        key = "gD";
        mode = "n";
        lua = true;
        silent = true;
        action = ''
          function()
            require('glance').open('references')
          end
        '';
        noremap = true;
        desc = "Show references in glance menu";
      }
      {
        key = "gd";
        mode = "n";
        lua = true;
        silent = true;
        action = ''
          function()
            require('glance').open('definitions')
          end
        '';
        noremap = true;
        desc = "Show definitions in glance menu";
      }

      # LSP utilities
      {
        key = "gl";
        mode = "n";
        lua = true;
        silent = true;
        action = ''
          function()
            vim.diagnostic.open_float()
          end
        '';
        noremap = true;
        desc = "Show line diagnostics";
      }
      {
        key = "gk";
        mode = "n";
        lua = true;
        silent = true;
        action = ''
          function()
            vim.lsp.buf.hover()
          end
        '';
        noremap = true;
        desc = "Show line diagnostics";
      }
      {
        key = "gr";
        mode = "n";
        lua = true;
        silent = true;
        action = /* lua */ ''
          function()
           vim.lsp.buf.rename()
          end
        '';
        noremap = true;
        desc = "LSP rename element";
      }

      # File navigation
      {
        key = "<C-e>";
        mode = [
          "n"
          "i"
        ];
        lua = true;
        action = /* lua */ ''
          function()
            if vim.fn.expand("%") ~= "" then
              vim.cmd("w")
            end
            require("yazi").yazi()
          end
        '';
        silent = true;
        noremap = true;
        desc = "Save current file and open Yazi";
      }

      # Clipboard
      {
        key = "<C-y>";
        mode = "v";
        action = ''"+y'';
        silent = true;
        noremap = true;
        desc = "Copy to system clipboard";
      }

      # Search navigation with timer reset
      {
        key = "n";
        mode = "n";
        lua = true;
        action = /* lua */ ''
          function()
            -- TODO: ignore if no match foudn.
            vim.g.searchcount_timestamp = vim.loop.now()
            vim.cmd.normal({ bang = true, args = {'n'} })
          end
        '';
        silent = true;
        desc = "Next match (reset searchcount timer)";
      }
      {
        key = "N";
        mode = "n";
        lua = true;
        action = /* lua */ ''
          function()
            -- TODO: ignore if no match found.
            vim.g.searchcount_timestamp = vim.loop.now()
            vim.cmd.normal({ bang = true, args = {'N'} })
          end
        '';
        silent = true;
        desc = "Previous match (reset searchcount timer)";
      }

      # Alt+b buffer alternation (tracking via autocmd below)
      {
        key = "<A-b>";
        mode = [
          "n"
          "i"
        ];
        lua = false;
        action = ":b#<CR>";
        silent = true;
        noremap = true;
        desc = "Switch to alternate file buffer";
      }
    ]
    ++ lib.optionals (!config.my.noAI) [
      # CodeCompanion (calling functions from ai/codecompanion.nix)
      {
        key = "<A-a>";
        mode = [
          "i"
          "n"
        ];
        lua = true;
        silent = true;
        action = /* lua */ ''
          function()
            vim.g.codecompanion_keymaps.toggle_chat()
          end
        '';
        noremap = true;
        desc = "Toggle CodeCompanion chat sidebar";
      }
      {
        key = "<A-f>";
        mode = [
          "i"
          "n"
        ];
        lua = true;
        silent = true;
        action = /* lua */ ''
          function()
            vim.g.codecompanion_keymaps.fullscreen()
          end
        '';
        noremap = true;
        desc = "Toggle CodeCompanion fullscreen";
      }
      {
        key = "<A-S-o>";
        mode = [
          "i"
          "n"
        ];
        silent = true;
        action = ":CodeCompanionSummaries<CR>";
        noremap = true;
        desc = "Open CodeCompanion history summaries";
      }
      {
        key = "<A-o>";
        mode = [
          "i"
          "n"
        ];
        silent = true;
        action = ":CodeCompanionHistory<CR>";
        noremap = true;
        desc = "Open CodeCompanion history ";
      }
      {
        key = "<A-n>";
        mode = [
          "i"
          "n"
        ];
        lua = true;
        silent = true;
        action = /* lua */ ''
          function()
            vim.g.codecompanion_keymaps.new_chat()
          end
        '';
        noremap = true;
        desc = "New CodeCompanion chat (in chat buffer only)";
      }
    ];
  };
}
