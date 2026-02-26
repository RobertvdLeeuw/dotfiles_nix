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
    luaConfigPost = /* lua */ ''
      -- Fix codecompanion telescope keybindings
      vim.api.nvim_create_autocmd("VimEnter", {
      	callback = function()
      		local ok, provider = pcall(require, "codecompanion.providers.actions.telescope")
      		if not ok then
      			return
      		end

      		local original_picker = provider.picker
      		provider.picker = function(self, items, opts)
      			opts = opts or {}
      			opts.attach_mappings = function(bufnr, map)
      				local telescope_actions = require("telescope.actions")
      				local action_state = require("telescope.actions.state")

      				-- Add explicit keybindings
      				map("i", "<M-j>", telescope_actions.move_selection_next)
      				map("i", "<M-k>", telescope_actions.move_selection_previous)

      				-- Keep original select behavior
      				telescope_actions.select_default:replace(function()
      					local selected = action_state.get_selected_entry()
      					if not selected or vim.tbl_isempty(selected) then
      						return
      					end
      					telescope_actions.close(bufnr)
      					self:select(selected.value)
      				end)

      				return true
      			end

      			return original_picker(self, items, opts)
      		end
      	end,
      })
    '';
  };
}
