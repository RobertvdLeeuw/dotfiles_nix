{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    assistant.codecompanion-nvim = {
      enable = true;
    };

    # Loading indicator autocmds
    autocmds = [
      # Show loading indicator when chat is submitted
      {
        event = [ "User" ];
        pattern = [ "CodeCompanionChatSubmitted" ];
        callback = lib.generators.mkLuaInline /* lua */ ''
          function(args)
            local bufnr = args.data.bufnr
            if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end

            -- Show loading indicator
            vim.api.nvim_buf_set_extmark(bufnr,
              vim.api.nvim_create_namespace("codecompanion_loading"),
              vim.api.nvim_buf_line_count(bufnr) - 1, 0, {
                id = 1,  -- Use fixed ID so we can clear it later
                virt_text = {{"⏳ Waiting for response...", "Comment"}},
                virt_text_pos = "eol"
              })
          end
        '';
        desc = "Show loading indicator when sending chat messages";
      }

      # Clear loading indicator when response starts streaming
      {
        event = [ "User" ];
        pattern = [ "CodeCompanionRequestStreaming" ];
        callback = lib.generators.mkLuaInline /* lua */ ''
          function(args)
            local bufnr = args.data.bufnr
            if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end

            -- Clear the loading indicator
            pcall(vim.api.nvim_buf_del_extmark, bufnr,
                  vim.api.nvim_create_namespace("codecompanion_loading"), 1)
          end
        '';
        desc = "Clear loading indicator when response starts";
      }
    ];

    # Setup call, keymap callback functions, and fullscreen setting
    luaConfigPost = /* lua */ ''
      -- Keymap callback functions (called from core/keymaps.nix)
      local M = {}

      function M.toggle_chat()
      	local codecompanion = require("codecompanion")
      	local last_chat = codecompanion.last_chat()

      	-- Check if there's a chat and if it's visible
      	if last_chat and not vim.tbl_isempty(last_chat) and last_chat.ui:is_visible() then
      		-- Remember if we were in fullscreen before closing
      		vim.g.codecompanion_was_fullscreen = vim.t.codecompanion_maximized or false

      		-- Close the chat
      		codecompanion.close_last_chat()
      		-- Clear the current fullscreen state since window is closed
      		vim.t.codecompanion_maximized = false
      	else
      		-- Open the chat
      		codecompanion.chat()
      		-- If we were previously in fullscreen, restore that state immediately
      		if vim.g.codecompanion_was_fullscreen then
      			vim.cmd("resize")
      			vim.cmd("vertical resize")
      			vim.t.codecompanion_maximized = true
      		end
      	end
      end

      function M.fullscreen()
      	local current_win = vim.api.nvim_get_current_win()
      	local buf = vim.api.nvim_win_get_buf(current_win)
      	local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

      	if filetype == "codecompanion" then
      		if vim.t.codecompanion_maximized then
      			-- Restore normal size
      			vim.cmd("wincmd =")
      			vim.t.codecompanion_maximized = false
      			vim.g.codecompanion_was_fullscreen = false
      		else
      			-- Maximize
      			vim.cmd("resize")
      			vim.cmd("vertical resize")
      			vim.t.codecompanion_maximized = true
      			vim.g.codecompanion_was_fullscreen = true
      		end
      	end
      end

      function M.actions()
      	if vim.bo.filetype == "codecompanion" then
      		require("codecompanion").actions()
      	end
      end

      function M.new_chat()
      	if vim.bo.filetype == "codecompanion" then
      		require("codecompanion").close_last_chat()
      		require("codecompanion").chat()
      	end
      end

      -- Export module for use in keymaps
      vim.g.codecompanion_keymaps = M

      -- CodeCompanion setup (deferred to ensure plugins are loaded)
      vim.defer_fn(function()
      	require("codecompanion").setup({
      		interactions = {
      			chat = {
      				adapter = "opencode",
      				model = "qwen2.5-coder:7b-48k",
      			},
      			inline = {
      				adapter = "opencode",
      				model = "qwen2.5-coder:7b-48k",
      			},
      		},

      		display = {
      			chat = {
      				start_in_insert_mode = true,
      				auto_scroll = true,
      				show_settings = true,
      				show_token_count = true,
      				intro_message = "CodeCompanion with OpenCode ✨ Press ? for help, <A-a> to close",
      			},
      			action_palette = {
      				provider = "telescope",
      				width = 120,
      				height = 15,
      			},
      		},
      		opts = {
      			log_level = "INFO",
      			send_code = true,
      			language = "English",
      		},
      	})
      end, 100)

      -- Start CodeCompanion on fullscreen.
      vim.g.codecompanion_was_fullscreen = true
    '';
  };
}
