{
  # config,
  pkgs,
  # inputs,
  lib,
  ...
}:

/*
  TODO
  - devcontainer
    - Fix start, terminal connect
    - open issue
    - Re-enable LSPs
    - Fix opencommit
      - Give high level notes
  - Agent stuff
    - CodeCompanion
    - minuet-ai.nvim? Blink AI comp
    - Skills
    - Agents.md?

  - Nested language support
  - Change formatting rules
  - LSP signature
  - Borders
  - Folding behavior
    - https://github.com/kevinhwang91/nvim-ufo
    - Auto on file open
    - no nest beyond func/meth bodies
  - Something debugger
  - Test integration https://www.youtube.com/watch?v=cf72gMBrsI0
*/

{
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "oxocarbon";
        style = "dark";
        # TODO: Find actual way to reset terminal colors, instead of hardcoding HEX colors everywhere
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
      statusline.lualine = {
        enable = true;
        setupOpts = {
          options = {
            theme = {
              _type = "lua-inline";
              expr = ''
                (function()
                  local theme = require('lualine.themes.auto')
                  local bg_color = '#111111'

                  -- Set section c background for all modes
                  for _, mode in pairs({'normal', 'insert', 'visual', 'replace', 'command', 'inactive'}) do
                    if theme[mode] and theme[mode].c then
                      theme[mode].c.bg = bg_color
                    end
                  end

                  return theme
                end)()
              '';
            };
          };
        };

        activeSection = {
          a = [
            ''
              {
                "mode",
                icons_enabled = true,
                color = { gui = "bold" },
                separator = {
                  -- left = '▎',
                  right = ''
                },
              }
            ''
            ''
              {
                "",
                draw_empty = true,
                separator = { left = '', right = '' }
              }
            ''
          ];
          b = [
            ''
              {
                "branch",
                color = { bg='#111111', fg='#b4befe', gui = "bold" },
                icon = "",
                -- separator = {right = ''}
              }
            ''
          ];
          c = [
            ''
              {
                "filename",
                color = {bg='#111111'},
                symbols = {modified = ' ', readonly = ' '},
                -- separator = {right = ''}
              }
            ''
          ];

          x = [
            ''
              {
                'searchcount',
                 fmt = function(str)  -- TODO: Make autodissappear
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
                -- separator = {left = ""}
              }
            ''
          ];
          y =
            let
              expected-lsps = ''
                local expected_lsps = {
                  bash = { "bash-ls" },
                  lua = { "lua-language-server" },
                  python = { "ty", "basedpyright" },
                  rust = { "rust-analyzer" },
                  sql = { "sqls" },
                  json = { "jsonls" },
                  nix = { "nil" }
                }
              '';
            in
            [
              ''
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
                      return " " .. table.concat(unexpected_lsps, ",")  -- All unexpected LSPs, purple
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
                        -- returning "" results in lsp icon not being rendered
                      end

                      if (current_time - grace_start) < 3 then
                        return " "  -- Yellow/grace: just icon, no text
                      else
                        -- Grace period over - show all missing LSPs in red
                        return " " .. table.concat(missing_lsps, ",")
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
                      return { fg = "white" }
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
                      return { fg = "purple" }
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
                        return { fg = "yellow" }
                      else
                        return { fg = "red" }
                      end
                    end

                    -- No LSPs
                    if #current_lsps == 0 then
                      return { fg = "gray" }
                    end

                    -- All good
                    return { fg = "white" }
                  end,
                  icon = "",
                  color = {bg='#1e1e1e'},
                  separator = {left = ''}
                }
              ''
              ''
                {
                  "diagnostics",
                  sources = {"nvim_lsp", "nvim_diagnostic", "nvim_diagnostic", "vim_lsp", "coc"},
                  symbols = {error = '󰅙  ', warn = '  ', info = '  ', hint = '󰌵 '},
                  colored = true,
                  update_in_insert = false,
                  always_visible = false,
                  diagnostics_color = {
                    color_error = { fg = "red" },
                    color_warn = { fg = "yellow" },
                    color_info = { fg = "cyan" },
                  },
                  color = {bg='#1e1e1e'},
                }
              ''
            ];

          z = [
            ''
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

                  local running = cli.container_is_running(workspace_dir)
                  -- TODO: Some ping-like command to devcontainer (devcontainer exec echo "test")

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
                icon = '',
                separator = {left = ''}
              }
            ''
          ];
        };
      };

      ui = {
        borders = {
          enable = true;
          globalStyle = "single";
          # lsp-signature.enable = true;
        };
        colorizer.enable = true;
        colorful-menu-nvim = {
          enable = true;
          setupOpts = { };
        };
      };

      keymaps = [
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
        {
          key = "<A-a>";
          mode = "n";
          lua = true;
          silent = true;
          action = ''
            function()
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
                  vim.cmd('resize')
                  vim.cmd('vertical resize')
                  vim.t.codecompanion_maximized = true
                end
              end
            end
          '';
          noremap = true;
          desc = "Toggle CodeCompanion chat sidebar";
        }
        {
          key = "<A-f>";
          mode = "n";
          lua = true;
          silent = true;
          action = ''
            function()
              local current_win = vim.api.nvim_get_current_win()
              local buf = vim.api.nvim_win_get_buf(current_win)
              local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

              if filetype == 'codecompanion' then
                if vim.t.codecompanion_maximized then
                  -- Restore normal size
                  vim.cmd('wincmd =')
                  vim.t.codecompanion_maximized = false
                  vim.g.codecompanion_was_fullscreen = false
                else
                  -- Maximize
                  vim.cmd('resize')
                  vim.cmd('vertical resize')
                  vim.t.codecompanion_maximized = true
                  vim.g.codecompanion_was_fullscreen = true
                end
              end
            end
          '';
          noremap = true;
          desc = "Toggle fullscreen for CodeCompanion chat";
        }
        {
          key = "<A-b>";
          mode = "n";
          lua = true;
          action = ''
            function()
              local current_buf = vim.api.nvim_get_current_buf()
              local alt_buf = vim.g.alternate_file_buffer

              -- Check if alternate buffer is valid and is a file buffer
              if alt_buf and
                 vim.api.nvim_buf_is_valid(alt_buf) and
                 vim.api.nvim_buf_is_loaded(alt_buf) and
                 vim.api.nvim_buf_get_name(alt_buf) ~= "" and
                 vim.bo[alt_buf].buftype == "" and
                 alt_buf ~= current_buf then
                vim.api.nvim_set_current_buf(alt_buf)
              else
                print("No alternate file buffer available")
              end
            end
          '';
          silent = true;
          noremap = true;
          desc = "Switch to alternate file buffer";
        }
        {
          key = "<C-e>";
          mode = "n";
          lua = true;
          action = ''
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
        # {
        #   key = "<C-f>";
        #   mode = [
        #     "n"
        #     "v"
        #   ];
        #   action = ":Telescope find_files hidden=true";
        #   silent = true;
        #   noremap = true;
        #   desc = "Copy to system clipboard";
        # }
        {
          key = "<C-y>";
          mode = [
            "n"
            "v"
          ];
          action = ''"+y'';
          silent = true;
          noremap = true;
          desc = "Copy to system clipboard";
        }
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
          key = "<C-p>";
          mode = "n";
          lua = true;
          silent = true;
          action = ''
            function()
              require('telescope').extensions.projects.projects{}
            end
          '';
          noremap = true;
          desc = "Open project picker";
        }
      ];

      autocmds = [
        {
          event = [ "BufEnter" ];
          pattern = [ "*" ];
          callback = {
            _type = "lua-inline";
            expr = ''
              function()
                local current_buf = vim.api.nvim_get_current_buf()
                local prev_buf = vim.g.current_file_buffer

                -- Only track file buffers
                if vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
                  -- Set previous file buffer as alternate
                  if prev_buf and
                     prev_buf ~= current_buf and
                     vim.api.nvim_buf_is_valid(prev_buf) and
                     vim.api.nvim_buf_get_name(prev_buf) ~= "" and
                     vim.bo[prev_buf].buftype == "" then
                    vim.g.alternate_file_buffer = prev_buf
                  end
                  -- Update current file buffer tracker
                  vim.g.current_file_buffer = current_buf
                end
              end
            '';
          };
          desc = "Track file buffer changes for Alt+b alternation";
        }
        {
          event = [ "BufReadPost" ];
          pattern = [ "*" ];
          command = "normal zM";
          desc = "Open all folds when reading a file";
        }
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

      options = {
        foldlevel = 20;
        foldlevelstart = 1;
        foldnestmax = 8;
        tabstop = 2;
        shiftwidth = 2;
      };

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          formatters_by_ft = {
            python = [
              "isort"
              "ruff_format"
            ];

            lua = [ "stylua" ];

            rust = {
              _type = "lua-inline";
              expr = ''{ "rustfmt", lsp_format = "fallback" }'';
            };

            bash = [ "shfmt" ];
            sh = [ "shfmt" ];
            json = [
              "prettier"
              "jq"
            ];
            nix = [ "nixfmt" ];
            sql = [ "sqlfmt" ];
            markdown = [ "prettier" ];

            # Fallback
            "*" = [ "trim_whitespace" ];
          };

          formatters = {
            shfmt = {
              append_args = [
                "-i"
                "2"
                "-ci"
              ];
            };

            ruff_format = {
              append_args = [
                "--line-length"
                "100"
              ];
            };

            nixfmt = {
              append_args = [
                "--width"
                "100"
              ];
            };
          };

          # Default format options
          default_format_opts = {
            lsp_format = "fallback";
            timeout_ms = 3000;
          };

          # Format on save configuration
          format_on_save = {
            _type = "lua-inline";
            expr = ''
              function()
                if not vim.g.formatsave or vim.b.disableFormatSave then
                  return
                else
                  return { lsp_format = "fallback", timeout_ms = 1000 }
                end
              end
            '';
          };

          # Notify settings
          notify_on_error = true;
          notify_no_formatters = false;
        };
      };

      languages = {
        bash = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };
        # html.enable = true;
        lua = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };
        python = {
          enable = true;
          treesitter.enable = true;
          lsp = {
            enable = true; # TODO: Are these settings just equivalent to enable = false?
            # servers = [ ]; # TODO: Get based working just from lsp.servers
          };
        };
        rust = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };
        sql = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };
        json = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };
        nix = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };
      };

      treesitter = {
        enable = true;
        fold = true;
      };

      lsp = {
        enable = true;
        formatOnSave = true; # TODO: False because conform-nvim?
        inlayHints.enable = true;
        lspSignature.enable = false; # Using blink-cmp
        servers = {
          basedpyright = {
            # cmd = lib.mkForce {
            #   _type = "lua-inline";
            #   expr = "require('devcontainers').lsp_cmd({ 'basedpyright-langserver', '--stdio' })";
            # };

            filetypes = [ "python" ];
            root_markers = [
              "pyproject.toml"
              "setup.cfg"
              "requirements.txt"
              "Pipfile"
              "pyrightconfig.json"
            ];

            settings.basedpyright = {
              analysis = {
                diagnosticSeverityOverrides = {
                  reportAny = "none";
                  reportUnknownMemberType = "none";
                  reportUnknownVariableType = "none";
                  reportMissingImports = "none"; # Handled by ty.
                };
              };
            };
          };

          ty = {
            # cmd = lib.mkForce {
            #   _type = "lua-inline";
            #   expr = "require('devcontainers').lsp_cmd({ 'ty', 'server' })";
            # };
            cmd = lib.mkDefault [
              (lib.getExe pkgs.ty)
              "server"
            ];
            filetypes = [ "python" ];
            root_markers = [
              "pyproject.toml"
              "setup.cfg"
              "requirements.txt"
              "Pipfile"
              "pyrightconfig.json"
            ];

            settings.ty = {
              configuration = {
                rules = {
                  _type = "lua-inline";
                  expr = ''{ ["unresolved-reference"] = "ignore" }'';
                };
              };
            };
          };
        };
      };

      luaConfigPost = ''
          -- TODO: Find better place for this diagnostics merging.
          -- Enhanced diagnostic merger that survives file saves
          local function setup_diagnostic_merger()
          local orig_virtual_text_handler = vim.diagnostic.handlers.virtual_text
          local merge_ns = vim.api.nvim_create_namespace("diagnostic_merger")

          local function merge_diagnostics(diagnostics)
            local merged = {}
            local seen = {}

            -- Sort diagnostics consistently: by line, column, severity, then source
            table.sort(diagnostics, function(a, b)
              if a.lnum ~= b.lnum then
                return a.lnum < b.lnum
              end
              if a.col ~= b.col then
                return a.col < b.col
              end
              if a.severity ~= b.severity then
                return a.severity < b.severity  -- Lower numbers = higher severity
              end
              -- Tie-breaker: source name
              local source_a = a.source or ""
              local source_b = b.source or ""
              return source_a < source_b
            end)

            for _, diag in ipairs(diagnostics) do
              local key = string.format("%d:%d:%s", diag.lnum, diag.col, diag.message:sub(1, 50))

              if not seen[key] then
                seen[key] = true
                table.insert(merged, diag)
              end
            end

            return merged
          end

          local function refresh_merged_diagnostics(args)
            local bufnr = args.buf
            if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
              return
            end

            -- Get all current diagnostics for this buffer
            local all_diagnostics = vim.diagnostic.get(bufnr)
            local merged_diagnostics = merge_diagnostics(all_diagnostics)

            -- Clear existing virtual text in our namespace
            orig_virtual_text_handler.hide(merge_ns, bufnr)

            -- Show merged diagnostics if we have any
            if #merged_diagnostics > 0 then
              -- Pass the full diagnostic config - the original handler extracts virtual_text from it
              local full_config = vim.diagnostic.config()
              orig_virtual_text_handler.show(merge_ns, bufnr, merged_diagnostics, full_config)
            end
          end

          -- Override the virtual text handler to prevent individual LSPs from showing diagnostics
          vim.diagnostic.handlers.virtual_text = {
            show = function(namespace, bufnr, diagnostics, opts)
              -- Only show if this is our merged namespace, ignore individual LSP namespaces
              if namespace == merge_ns then
                orig_virtual_text_handler.show(namespace, bufnr, diagnostics, opts)
              end
            end,

            hide = function(namespace, bufnr)
              if namespace == merge_ns then
                orig_virtual_text_handler.hide(namespace, bufnr)
              end
            end
          }

          -- Re-merge diagnostics whenever they change from any source
          vim.api.nvim_create_autocmd("DiagnosticChanged", {
            callback = refresh_merged_diagnostics,
            desc = "Refresh merged diagnostic virtual text"
          })

          -- Also refresh on initial buffer diagnostics
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              vim.defer_fn(function()
                refresh_merged_diagnostics(args)
              end, 100)
            end,
          })
        end

        -- Initialize the merger
        vim.defer_fn(setup_diagnostic_merger, 50)

        -- LSP DEVCONTAINER STUFF
        vim.lsp.set_log_level('debug')

        -- Force CodeCompanion setup if it hasn't been initialized
        vim.defer_fn(function()
          if not pcall(function() return require("codecompanion.config") end) then
            require("codecompanion").setup({
              adapters = {
                ollama = function()
                  return require("codecompanion.adapters").extend("ollama", {
                    name = "ollama",
                    env = {
                      url = "http://localhost:11434",
                    },
                    headers = {
                      ["Content-Type"] = "application/json",
                    },
                    parameters = {
                      sync = true,
                    },
                    schema = {
                      model = {
                        default = "qwen2.5-coder:7b-instruct",
                      },
                    },
                  })
                end,
              },
              strategies = {
                chat = {
                  adapter = "ollama",
                  keymaps = {
                    options = {
                      modes = { "n" },
                      silent = true,
                      noremap = true,
                    },
                    ["<A-b>"] = "close",
                  },
                },
                inline = {
                  adapter = "ollama",
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
          end
        end, 100)

        -- Start CodeCompanion on fullscreen.
        vim.g.codecompanion_was_fullscreen = true
      '';

      autocomplete.blink-cmp = {
        enable = true;

        mappings = {
          confirm = "<Tab>";

          next = "<A-j>";
          previous = "<A-k>";

          scrollDocsDown = "<C-j>";
          scrollDocsUp = "<C-k>";
        };

        setupOpts = {
          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
          };

          completion = {
            menu = {
              min_width = 15;
              max_height = 10;

              draw = {
                columns = [
                  [ "kind_icon" ]
                  [ "label" ]
                ];

                components = {
                  kind_icon = {
                    highlight = {
                      _type = "lua-inline";
                      expr = ''
                        function(ctx)
                          return require("colorful-menu").blink_components_highlight(ctx)
                        end
                      '';
                    };
                  };

                  label = {
                    text = {
                      _type = "lua-inline";
                      expr = ''
                        function(ctx)
                          return require("colorful-menu").blink_components_text(ctx)
                        end
                      '';
                    };
                    highlight = {
                      _type = "lua-inline";
                      expr = ''
                        function(ctx)
                          return require("colorful-menu").blink_components_highlight(ctx)
                        end
                      '';
                    };
                  };
                };
              };
            };

            documentation = {
              window = {
                min_width = 10;
                max_width = 80;
                max_height = 20;

                desired_min_width = 50;
                desired_min_height = 10;

                border = "single";

                direction_priority = {
                  menu_north = [
                    "e"
                    "n"
                    "s"
                  ];
                  menu_south = [
                    "e"
                    "s"
                    "n"
                  ];
                };
              };
              auto_show_delay_ms = 200;
            };
          };

          keymap = {
            "<A-Tab>" = [
              "snippet_forward"
              "fallback"
            ];
            "<A-S-Tab>" = [
              "snippet_backward"
              "fallback"
            ];
          };

          cmdline = {
            completion.menu.auto_show = true;
            keymap.preset = "inherit";
          };
        };
        friendly-snippets.enable = true;
      };

      telescope = {
        enable = true;
        extensions = [
          {
            name = "fzf";
            packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
            setup.fzf.fuzzy = true;
          }
          {
            name = "projects";
            packages = [ pkgs.vimPlugins.project-nvim ];
            setup = {
              _type = "lua-inline";
              expr = ''
                {
                  -- Disable all default telescope keymaps for project picker
                  mappings = {
                    i = {},
                    n = {},
                  },
                }
              '';
            };
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
              "--hidden"
              # "--no-ignore"
            ];
            mappings.i = {
              _type = "lua-inline";
              expr = ''{["<esc>"] = require("telescope.actions").close}'';
            };
          };
          pickers.find_files.find_command = [
            "${pkgs.ripgrep}/bin/rg"
            "--files"
            "--hidden"
          ];
        };
      };

      notes = {
        todo-comments = {
          enable = true;
          mappings.telescope = "<S-t>";
        };
      };

      navigation.harpoon = {
        enable = true;
        mappings = {
          file1 = "<A-1>";
          file2 = "<A-2>";
          file3 = "<A-3>";
          file4 = "<A-4>";

          listMarks = "<A-Space>";
          markFile = "<A-m>";
        };
      };

      terminal = {
        toggleterm = {
          enable = true;
          mappings.open = "<C-Space>";
          setupOpts = {
            direction = "horizontal";
            size = {
              _type = "lua-inline";
              expr = "function(term) return (10 + vim.o.lines / 4) end";
            };

            winbar.enabled = false;

            on_create = {
              _type = "lua-inline";
              expr = ''
                function(t)
                  local manager = require("devcontainers.manager")
                  local cli = require("devcontainers.cli")

                  local workspace_dir = manager.find_workspace_dir()
                  if cli.container_is_running(workspace_dir) then
                    t.send("devcontainer exec /bin/bash")
                  end
                end
              '';
            };
            # Smart shell that auto-targets devcontainers
            shell = {
              _type = "lua-inline";
              expr = ''
                function()
                  -- local workspace_dir = require("devcontainers.manager").find_workspace_dir()
                  -- if not workspace_dir then return vim.o.shell end

                  -- local cli = require('devcontainers.cli')
                  -- if not cli.container_is_running(workspace_dir) then
                    -- vim.api.nvim_command('DevcontainersUp')
                    -- TODO: while not running: sleep with timeout
                  -- end

                  return vim.o.shell
                  -- return table.concat(cli.cmd(workspace_dir, 'exec', '/bin/bash'), " ")
                end
              '';
            };
          };
        };
      };

      autopairs.nvim-autopairs.enable = true;
      comments.comment-nvim = {
        enable = true;
        mappings = {
          toggleCurrentLine = "<C-c>";
          toggleSelectedLine = "<C-c>";
        };
      };

      snippets.luasnip.enable = true;

      diagnostics = {
        enable = true;
        config = {
          underline = false;

          virtual_text = {
            spacing = 4;
            prefix = "■";
            format = {
              _type = "lua-inline";
              expr = ''
                function(diagnostic)
                  return diagnostic.message
                end
              '';
            };
          };

          signs = false;

          severity_sort = true;

          float = {
            severity_sort = true;

            focusable = false;
            # style = "minimal";
            border = "single"; # TODO: Make this work.
            source = "always";
            header = "";
            prefix = "";
          };

          update_in_insert = false;
        };

        nvim-lint = {
          enable = true;

          # Configure linters by filetype
          linters_by_ft = {
            # Python - use ruff for comprehensive linting
            python = [ "ruff" ];

            lua = [ "luacheck" ];

            # Rust - use clippy for advanced linting (beyond LSP)
            rust = [ "clippy" ];

            # Shell/Bash - use shellcheck for shell script analysis
            bash = [ "shellcheck" ];
            sh = [ "shellcheck" ];

            # JSON - use jsonlint for validation
            # json = [ "jsonlint" ];

            # Nix - use statix for static analysis and nix-linter
            nix = [
              "statix"
              "nix"
            ];

            # SQL - use sqlfluff for SQL style and error checking
            sql = [ "sqlfluff" ];

            # Markdown - use markdownlint for style and formatting issues
            markdown = [ "markdownlint" ];

            # YAML - use yamllint
            yaml = [ "yamllint" ];
            yml = [ "yamllint" ];

            # JavaScript/TypeScript (if you add them later)
            # javascript = [ "eslint_d" ];
            # typescript = [ "eslint_d" ];

            # HTML (if you enable it)
            # html = [ "htmlhint" ];

            # CSS (if you add it)
            # css = [ "stylelint" ];
          };

          # Customizations for specific linters
          linters = {
            ruff = {
              args = [
                "--output-format"
                "json"
                "--no-cache"
                "--exit-zero"
                "--stdin-filename"
                {
                  _type = "lua-inline";
                  expr = "vim.api.nvim_buf_get_name(0)";
                }
                "-"
              ];
            };

            luacheck = {
              args = [
                "--globals"
                "vim"
                "--formatter"
                "plain"
                "--codes"
                "--ranges"
                "-"
              ];
            };

            shellcheck = {
              args = [
                "--format"
                "json"
                "-"
              ];
            };

            markdownlint = {
              args = [
                "--stdin"
                "--json"
              ];
            };

            yamllint = {
              args = [
                "--format"
                "parsable"
                "-"
              ];
            };
          };
        };
      };

      assistant.codecompanion-nvim = {
        enable = true;
      };

      projects.project-nvim = {
        enable = true;
        setupOpts = {
          manual_mode = false;

          detection_methods = [
            "lsp"
            "pattern"
          ];

          patterns = [
            ".git"
            "_darcs"
            ".hg"
            ".bzr"
            ".svn"
            "Makefile"
            "package.json"
            "flake.nix"
            "cargo.toml"
            "pyproject.toml"
          ];

          # Exclude directories from your setup
          exclude_dirs = [
            "/mnt/storage/nc/Personal/Projects"
            "/home/robert/"
          ];

          # Don't show hidden files in telescope
          show_hidden = false;

          # Silent directory changes
          silent_chdir = true;

          # Change directory scope
          scope_chdir = "global";
        };
      };

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };

      utility = {
        yazi-nvim = {
          enable = true;

          setupOpts = {
            config_home = "/etc/nixos/modules/nvim/plugin/yazi/";

            open_for_directories = true;
            yazi_floating_window_border = "none";
            floating_window_scaling_factor = 1;

            keymaps = {
              show_help = "<f1>";

              # Disable other keymaps
              open_file_in_vertical_split = false;
              open_file_in_horizontal_split = false;
              open_file_in_tab = false;
              grep_in_directory = false;
              replace_in_directory = false;
              cycle_open_buffers = false;
              copy_relative_path_to_selected_files = false;
              send_to_quickfix_list = false;
            };
          };
        };
      };
      extraPlugins = {
        glance-nvim = {
          package = pkgs.vimPlugins.glance-nvim;
          setup = ''
            local glance = require('glance')
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
                position = 'right', -- Position relative to main window
                width = 0.33, -- Width as percentage of screen
              },

              -- Customize appearance to match your blink-cmp style
              theme = {
                enable = true,
                mode = 'auto',
              },

              -- Configure the floating window border
              border = {
                enable = true,
                style = 'single', -- Match your LSP border style
              },

              -- Key mappings within the glance window
              mappings = {
                list = {
                  ['<A-j>'] = actions.next,      -- Match your blink-cmp navigation
                  ['<A-k>'] = actions.previous,  -- Match your blink-cmp navigation
                  ['<Tab>'] = actions.jump,       -- Match your blink-cmp confirm
                  ['<CR>'] = actions.jump,
                  ['<Esc>'] = actions.close,
                  ['q'] = actions.close,
                },

                preview = {
                  ['<A-j>'] = actions.next,      -- Match your blink-cmp navigation
                  ['<A-k>'] = actions.previous,  -- Match your blink-cmp navigation
                  ['<Tab>'] = actions.jump,       -- Match your blink-cmp confirm
                  ['<CR>'] = actions.jump,
                  ['<Esc>'] = actions.close,
                  ['q'] = actions.close,
                },
              },
            })
          '';
        };
        # nvim-dev-container = {
        #   # General/main devcontainer plugin
        #   package = pkgs.vimUtils.buildVimPlugin {
        #     pname = "nvim-dev-container";
        #     version = "2026-02-13";
        #     src = pkgs.fetchFromGitHub {
        #       owner = "RobertvdLeeuw";
        #       repo = "nvim-dev-container-premium-edition";
        #       rev = "main";
        #       hash = "sha256-5zo2Gc3nekawkodj47uN7stXZqGiT1DZdldJFnHNgOc=";
        #     };
        #   };
        #   setup = ''
        #     require("devcontainer").setup {
        #       autocommands = {
        #         init = true,
        #         clean = true,
        #         update = true,
        #       },
        #
        #       container_runtime = "docker",
        #       disable_recursive_config_search = false,
        #     }
        #   '';
        # };
        devcontainers-nvim = {
          # For LSP-in-devcontainer stuff
          package = pkgs.vimUtils.buildVimPlugin {
            pname = "devcontainers-nvim";
            version = "2026-02-14";
            src = pkgs.fetchFromGitHub {
              owner = "jedrzejboczar";
              repo = "devcontainers.nvim";
              rev = "master";
              hash = "sha256-tHwN2x6lMq+KdNMzyccMIIq+C9rvSRb9RKtKg7DxrLk=";

              # owner = "RobertvdLeeuw";
              # repo = "devcontainers.nvim-premium-edition";
              # rev = "master";
              # hash = "sha256-twY2Yy4ns+bQY0szjFxLaEB1TpButc8tIV4ByTLCHc4=";
            };

            doCheck = false;
          };
          setup = ''
            require('devcontainers').setup({
              log = { level = 'trace' }
              -- , use_docker_exec = false
            })
          '';
        };
        netman-nvim = {
          # For devcontainers.nvim
          package = pkgs.vimUtils.buildVimPlugin {
            pname = "netman-nvim";
            version = "2026-02-14";
            src = pkgs.fetchFromGitHub {
              owner = "miversen33";
              repo = "netman.nvim";
              rev = "master";
              hash = "sha256-SmpAuhDM764kT8BG1XWztNt3CJITohhrGoaB3DBo0U0=";
            };

            doCheck = false;
          };
          setup = ''
            require('netman')
          '';
        };
      };

      extraPackages = [
        pkgs.fzf
        pkgs.ripgrep
        pkgs.yazi

        # Formatter packages
        pkgs.stylua # Lua
        pkgs.shfmt # Shell/Bash
        pkgs.nodePackages.prettier # JSON, Markdown
        pkgs.jq # JSON fallback
        pkgs.nixfmt-rfc-style # Nix
        pkgs.ruff # Python (includes ruff_format and ruff linter)
        pkgs.python311Packages.isort # Python import sorting
        pkgs.python313Packages.sqlfmt # SQL

        # Linter packages
        pkgs.luajitPackages.luacheck # Lua linter
        pkgs.clippy # Rust linter (usually comes with rust toolchain)
        pkgs.shellcheck # Shell script linter
        # pkgs.nodePackages.jsonlint # JSON linter
        pkgs.statix # Nix static analyzer
        # pkgs.nix-linter # Additional Nix linting
        pkgs.sqlfluff # SQL linter
        pkgs.nodePackages.markdownlint-cli # Markdown linter
        pkgs.yamllint # YAML linter

        # Additional useful linters for potential future use
        # pkgs.nodePackages.eslint_d # JavaScript/TypeScript (fast)
        # pkgs.nodePackages.htmlhint # HTML
        # pkgs.nodePackages.stylelint # CSS
      ];
    };
  };
}
