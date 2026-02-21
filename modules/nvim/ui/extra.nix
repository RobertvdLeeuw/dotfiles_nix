{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    notes = {
      todo-comments = {
        enable = true;
        mappings.telescope = "<S-t>";
      };
    };

    extraPlugins = {
      glance-nvim = {
        package = pkgs.vimPlugins.glance-nvim;
        setup = /* lua */ ''
          local glance = require("glance")
          local actions = glance.actions

          glance.setup({
          	height = 18, -- Height of the floating window
          	zindex = 45, -- Z-index for the window

          	-- Position the window near cursor (similar to completion menu)
          	preview_win_opts = {
          		cursorline = true,
          		number = true,
          		wrap = true,
          	},

          	hooks = {
          		before_open = function(results, open, jump, method)
          			local uri = vim.uri_from_bufnr(0)
          			if #results == 1 then
          				-- If only one result, jump directly instead of opening menu
          				jump(results[1])
          				return
          			end
          			open(results)
          		end,
          	},

          	list = {
          		position = "right", -- Position relative to main window
          		width = 0.33, -- Width as percentage of screen
          	},

          	-- Customize appearance to match your blink-cmp style
          	theme = {
          		enable = true,
          		mode = "auto",
          	},

          	-- Configure the floating window border
          	border = {
          		enable = true,
          		style = "single", -- Match your LSP border style
          	},

          	-- Key mappings within the glance window
          	mappings = {
          		list = {
          			["<A-j>"] = actions.next, -- Match your blink-cmp navigation
          			["<A-k>"] = actions.previous, -- Match your blink-cmp navigation
          			["<Tab>"] = actions.jump, -- Match your blink-cmp confirm
          			["<CR>"] = actions.jump,
          			["<Esc>"] = actions.close,
          			["q"] = actions.close,
          		},

          		preview = {
          			["<A-j>"] = actions.next, -- Match your blink-cmp navigation
          			["<A-k>"] = actions.previous, -- Match your blink-cmp navigation
          			["<Tab>"] = actions.jump, -- Match your blink-cmp confirm
          			["<CR>"] = actions.jump,
          			["<Esc>"] = actions.close,
          			["q"] = actions.close,
          		},
          	},
          })
        '';
      };
    };
  };
}
