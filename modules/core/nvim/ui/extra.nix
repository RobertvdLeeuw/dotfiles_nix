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

    ui.noice = {
      # Cmdline popup
      enable = true;
      setupOpts = {
        presets = {
          bottom_search = false;
          command_palette = false;
          long_message_to_split = false;
          lsp_doc_border = false;
        };

        messages.enabled = false;
        notify.enabled = false;

        lsp = {
          progress.enabled = false;
          hover.enabled = false;
          signature.enabled = false;
          message.enabled = false;
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = false;
            "vim.lsp.util.stylize_markdown" = false;
            "cmp.entry.get_documentation" = false;
          };
        };

        routes = [
          # TODO: fix
          # {
          #   # Pattern not found error
          #   filter = {
          #     event = "msg_show";
          #     find = "E486";
          #   };
          #   opts = {
          #     skip = true;
          #   };
          # }
        ];
      };
    };

    options.cmdheight = 0;
    luaConfigPost = /* lua */ ''
      vim.opt.shortmess:append("s")
    '';

    extraPlugins = {
      glance-nvim = {
        # Preview menu for LSP locations

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
