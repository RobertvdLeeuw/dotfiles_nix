{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    statusline.lualine = {
      enable = true;
      setupOpts = {
        options = {
          theme = lib.generators.mkLuaInline /* lua */ ''
            (function()
            	local theme = require("lualine.themes.auto")
            	local bg_color = "#111111"

            	-- Set section c background for all modes
            	for _, mode in pairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
            		if theme[mode] and theme[mode].c then
            			theme[mode].c.bg = bg_color
            		end
            	end

            	return theme
            end)()
          '';
        };
      };

      activeSection = {
        a = [
          /* lua */ ''
            {
              "mode",
              icons_enabled = true,
              color = { gui = "bold" },
              separator = {
                right = ''
              }
            }
          ''
        ];
        b = [
          /* lua */ ''
            {
              "branch",
              color = { bg='#111111', fg='#b4befe', gui = "bold" },
              icon = "",
            }
          ''
          /* lua */ ''
            {
              "",
              draw_empty = true,
              color = { bg='#333333' },
              separator = {left = '', right = ""}
            }
          ''
        ];
        c = [
          /* lua */ ''
            {
              "filename",
              color = {bg='#111111'},
              symbols = {modified = ' ', readonly = ' '},
            }
          ''
        ];

        x = [
          /* lua */ ''
            {
              'searchcount',
              fmt = function(str)
                if not vim.g.searchcount_timestamp then
                  vim.g.searchcount_timestamp = vim.loop.now()
                end

                local elapsed = vim.loop.now() - vim.g.searchcount_timestamp
                if elapsed > 3000 then
                  return ""  -- Auto disappearing
                end

                local text = str:gsub('[%[%]]', "")

                if text == '0/0' then
                  return "Not found"
                else
                  return text
                end
              end,
              maxcount = 99,
              timeout = 10,
              color = {bg='#111111'},
            }
          ''
        ];
        y =
          let
            expected-lsps = /* lua */ ''
              local expected_lsps = {
              	bash = { "bash-ls" },
              	lua = { "lua-language-server" },
              	python = { "ty", "basedpyright" },
              	rust = { "rust-analyzer" },
              	sql = { "sqls" },
              	json = { "jsonls" },
              	nix = { "nil" },
              }
            '';
          in
          [
            /* lua */ ''
              {
              "",
                draw_empty = true,
                color = { bg='#333333' },
                separator = {left = "", right = ''}
              }
            ''
            /* lua */ ''
              {
                function()
                  local buf_ft = vim.bo.filetype
                  local excluded_buf_ft = { toggleterm = true, NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true }

                  if excluded_buf_ft[buf_ft] then
                    return " "
                  end

                  ${expected-lsps}

                  local bufnr = vim.api.nvim_get_current_buf()
                  local clients = vim.lsp.get_clients({ bufnr = bufnr })

                  local current_lsps = {}
                  for _, client in ipairs(clients) do
                    table.insert(current_lsps, client.name)
                  end

                  local expected = expected_lsps[buf_ft] or {}

                  -- Check for unexpected LSPs (PURPLE - highest priority, trumps everything)
                  local unexpected_lsps = {}
                  for _, current_lsp in ipairs(current_lsps) do
                    local found = false
                    for _, expected_lsp in ipairs(expected) do
                      if current_lsp == expected_lsp then
                        found = true
                        break
                      end
                    end
                    if not found then
                      table.insert(unexpected_lsps, current_lsp)
                    end
                  end

                  if #unexpected_lsps > 0 then
                    -- All unexpected LSPs, purple
                    return " " .. table.concat(unexpected_lsps, ",") .. "  "
                  end

                  -- Check for missing expected LSPs
                  local missing_lsps = {}
                  for _, expected_lsp in ipairs(expected) do
                    local found = false
                    for _, current_lsp in ipairs(current_lsps) do
                      if current_lsp == expected_lsp then
                        found = true
                        break
                      end
                    end
                    if not found then
                      table.insert(missing_lsps, expected_lsp)
                    end
                  end

                  -- Handle missing LSPs with grace period
                  if #missing_lsps > 0 then
                    local current_time = vim.fn.localtime()
                    local grace_start = vim.b.lsp_grace_start  -- TODO: Make table keyed by bufnr

                    if not grace_start then
                      vim.b.lsp_grace_start = current_time
                      return " "  -- Yellow/grace: just icon, no text
                    end

                    if (current_time - grace_start) < 3 then
                      return " "  -- Yellow/grace: just icon, no text
                    else
                      -- Grace period over - show all missing LSPs in red
                      return " " .. table.concat(missing_lsps, ",") .. "  "
                    end
                  else
                    -- Reset grace period if no missing LSPs
                    vim.b.lsp_grace_start = nil
                  end

                  -- No issues - return space (just icon, no text - will be white)
                  return " "
                end,
                color = function()
                  local buf_ft = vim.bo.filetype
                  local excluded_buf_ft = { toggleterm = true, NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true }

                  if excluded_buf_ft[buf_ft] then
                    return { bg='#111111', fg = "white" }
                  end

                  ${expected-lsps}

                  local bufnr = vim.api.nvim_get_current_buf()
                  local clients = vim.lsp.get_clients({ bufnr = bufnr })

                  local current_lsps = {}
                  for _, client in ipairs(clients) do
                    table.insert(current_lsps, client.name)
                  end

                  local expected = expected_lsps[buf_ft] or {}

                  -- Check for unexpected LSPs first (purple trumps)
                  local has_unexpected = false
                  for _, current_lsp in ipairs(current_lsps) do
                    local found = false
                    for _, expected_lsp in ipairs(expected) do
                      if current_lsp == expected_lsp then
                        found = true
                        break
                      end
                    end
                    if not found then
                      has_unexpected = true
                      break
                    end
                  end

                  if has_unexpected then
                    return { bg='#111111', fg = "purple" }
                  end

                  -- Check for missing LSPs
                  local missing_count = 0
                  for _, expected_lsp in ipairs(expected) do
                    local found = false
                    for _, current_lsp in ipairs(current_lsps) do
                      if current_lsp == expected_lsp then
                        found = true
                        break
                      end
                    end
                    if not found then
                      missing_count = missing_count + 1
                    end
                  end

                  if missing_count > 0 then
                    local current_time = vim.fn.localtime()
                    local grace_start = vim.b.lsp_grace_start

                    if grace_start and (current_time - grace_start) < 3 then
                      return { bg='#111111', fg = "yellow" }
                    else
                      return { bg='#111111', fg = "red" }
                    end
                  end

                  -- No LSPs
                  if #current_lsps == 0 then
                    return { bg='#111111', fg = "gray" }
                  end

                  -- All good
                  return { bg='#111111', fg = "white" }
                end,
                padding = { left = 1, right = 0 },
                icon = "",
              }
            ''
            /* lua */ ''
              {
                "diagnostics",
                sources = {"nvim_lsp", "nvim_diagnostic", "nvim_diagnostic", "vim_lsp", "coc"},
                symbols = {error = '󰅙 ', warn = ' ', info = ' ', hint = '󰌵'},
                colored = true,
                update_in_insert = false,
                always_visible = false,
                diagnostics_color = {
                  color_error = { fg = "red" },
                  color_warn = { fg = "yellow" },
                  color_info = { fg = "cyan" },
                },
                color = {bg='#11111'},
                padding = { left = 0, right = 1 },
              }
            ''
          ];

        z = [
          /* lua */ ''
            {
              function() return " " end,
              color = function ()
                local cli = require('devcontainers.cli')
                local manager = require('devcontainers.manager')

                local workspace_dir = manager.find_workspace_dir()

                if not workspace_dir then
                  -- TODO: Check for unexpected container (purple)
                  return { bg = 'grey', fg = "#1e1e1e"}
                end

                local running = vim.g.devcontainer_running

                if not running then
                  local current_time = vim.fn.localtime()
                  -- TODO: Skip grace if not the first buffer opened.
                  local grace_start = vim.b.devcontainer_grace_start

                  if not grace_start then
                    vim.b.devcontainer_grace_start = current_time
                    return { bg = 'yellow', fg = "#1e1e1e"}
                  end

                  if (current_time - grace_start) < 3 then
                    return { bg = 'yellow', fg = "#1e1e1e"}
                  end

                  -- TODO: Some logic to make sure it's the right container.
                  return { bg = 'red', fg = "#1e1e1e"}
                end

                return { bg = 'white', fg = "#1e1e1e"}
              end,
              padding = { left = 1, right = 0 },
              icon = '',
              separator = {left = ''}
            }
          ''
        ];
      };
    };

    # Searchcount autocmd (resets timer on command leave)
    autocmds = [
      {
        event = [ "CmdlineLeave" ];
        pattern = [
          "/"
          "?"
          ":"
        ];
        callback = lib.generators.mkLuaInline /* lua */ ''
          function()
            vim.g.searchcount_timestamp = vim.loop.now()
          end
        '';
        desc = "Disable searchcount in lualine upon new command";
      }
    ];

    # Async container status checker and shortmess setting
    luaConfigPost = /* lua */ ''
      -- Background async container status checker
      local container_status_timer = vim.loop.new_timer()

      local function update_container_status()
      	local cli = require("devcontainers.cli")
      	local manager = require("devcontainers.manager")
      	local workspace_dir = manager.find_workspace_dir()

      	if not workspace_dir then
      		vim.g.devcontainer_running = nil
      		return
      	end

      	-- Async check - doesn't block
      	vim.system(cli.cmd(workspace_dir, "exec", "echo"), { text = true }, function(result)
      		vim.schedule(function()
      			vim.g.devcontainer_running = result.code == 0
      		end)
      	end)
      end

      -- Check every 800ms
      container_status_timer:start(0, 800, vim.schedule_wrap(update_container_status))

      -- Disables [index/total] search in cmdline.
      vim.opt.shortmess:append("S")
    '';
  };
}
