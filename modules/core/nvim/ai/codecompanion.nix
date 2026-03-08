{
  pkgs,
  lib,
  ...
}:
{
  # TODO: Figure out why chat open freeze.
  settings.vim = {
    assistant.codecompanion-nvim = {
      enable = true;
    };
    # Setup call, keymap callback functions, and fullscreen setting
    luaConfigPost = /* lua */ ''
      require("codecompanion").setup({
      	interactions = {
      		background = {
      			adapter = { name = "opencode", model = "qwen3.5:9b-48k" },
      		},
      		chat = {
      			adapter = { name = "opencode", model = "qwen3.5:9b-48k" },
      		},
      		inline = {
      			adapter = { name = "opencode", model = "qwen3.5:9b-48k" },
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
      			width = 119,
      			height = 14,
      		},
      	},
      	opts = {
      		log_level = "INFO",
      		send_code = true,
      		language = "English",
      	},

      	extensions = {
      		spinner = {},

      		history = {
      			opts = {
      				---When chat is cleared with `gx` delete the chat from history
      				delete_on_clearing_chat = false,

      				summary = { -- TODO: Play with these settings/keymaps
      					create_summary_keymap = "gcs",
      				},

      				memory = {
      					auto_create_memories_on_summary_generation = true,
      					index_on_startup = true,
      				},

      				dir_to_save = vim.fn.stdpath("data") .. "/codecompanion_chats/", -- Per project instead of global?

      				auto_generate_title = true,
      				title_generation_opts = {
      					adapter = { name = "ollama", model = "qwen3.5:9b-48k" },
      					refresh_every_n_prompts = 3,
      					max_refreshes = 5,
      					-- format_title = function(original_title)
      					-- 	-- this can be a custom function that applies some custom
      					-- 	-- formatting to the title.
      					-- 	return original_title
      					-- end,
      				},
      			},
      		},

      		mcphub = {
      			callback = "mcphub.extensions.codecompanion",
      			opts = {
      				-- Make individual tools (@server__tool) and server groups (@server) from MCP servers
      				make_tools = true,

      				-- Show individual tools in chat completion (when make_tools=true)
      				show_server_tools_in_chat = true,

      				-- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
      				add_mcp_prefix_to_tool_names = false,

      				-- Show tool results directly in chat buffer
      				show_result_in_chat = true,

      				-- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
      				format_tool = nil,

      				-- Convert MCP resources to #variables for prompts
      				make_vars = true,

      				-- Add MCP prompts as /slash commands
      				make_slash_commands = true,
      			},
      		},
      	},
      })

      -- Keymap callback functions (called from core/keymaps.nix)
      local M = {}

      function M.toggle_chat()
      	local codecompanion = require("codecompanion")

      	-- Call the built-in toggle - handles "last chat or new" logic
      	codecompanion.toggle()

      	-- After toggle, check if chat became visible
      	local last_chat = codecompanion.last_chat()
      	if last_chat and last_chat.ui:is_visible() and vim.t.codecompanion_maximized then
      		vim.cmd("resize")
      		vim.cmd("vertical resize")
      	end
      end

      -- TODO: Closing toggleterm on when fullscreen chat resizes pane

      function M.fullscreen(toggle)
      	local current_win = vim.api.nvim_get_current_win()
      	local buf = vim.api.nvim_win_get_buf(current_win)
      	local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

      	if filetype == "codecompanion" then
      		if vim.t.codecompanion_maximized then
      			-- Restore normal size
      			vim.cmd("wincmd =")
      			vim.t.codecompanion_maximized = false
      		-- vim.t.codecompanion_maximized_win = nil
      		else
      			-- Maximize
      			vim.cmd("resize")
      			vim.cmd("vertical resize")
      			vim.t.codecompanion_maximized = true
      			-- vim.t.codecompanion_maximized_win = current_win
      		end
      	end
      end

      function M.new_chat()
      	-- TODO: Fix the stupid goddamn bullshit secret default to copilot no matter how deep and often I have to ram qwen3.5 into the asshole of codecompanion.
      	if vim.bo.filetype == "codecompanion" then
      		require("codecompanion").close_last_chat()
      		require("codecompanion").chat()

      		if vim.t.codecompanion_maximized then
      			vim.cmd("resize")
      			vim.cmd("vertical resize")
      		end
      	end
      end

      -- Export module for use in keymaps
      vim.g.codecompanion_keymaps = M
    '';

    extraPlugins = {
      # Extension
      cc-spinner.package = pkgs.vimPlugins.codecompanion-spinner-nvim;
      cc-history.package = pkgs.vimPlugins.codecompanion-history-nvim;
      mcphub-nvim.package = pkgs.vimPlugins.mcphub-nvim;
      # cc-lualine.package = pkgs.vimPlugins.codecompanion-lualine-nvim;
    };
  };
}
