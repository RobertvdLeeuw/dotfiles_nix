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
    - sync LSP/TS errors with devcontainer (no "package not found" by looking in the wrong place)
    - Direnv kinda thing (vim.utility.direnv)
  - Agent stuff

  - Alt+B: Back-n-forth last 2 files/buffers
  - gD -> usage menu
  - Telescope find_files show hidden
  - Git autogen commit message like CoPilot
  - Nested language support
  - Autocomp menu looks
  - Change formatting rules
  - LSP signature
  - Borders
  - Fix clipboard
  - Folding behavior
    - https://github.com/kevinhwang91/nvim-ufo
    - Auto on file open
    - no nest beyond func/meth bodies
  - Something debugger
  - https://www.youtube.com/watch?v=cf72gMBrsI0
*/

{
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "oxocarbon";
        style = "dark";
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
        {
          key = "<C-y>";
          mode = [
            "n"
            "v"
          ];
          action = ''[["+y]]'';
          desc = "Copy to system clipboard";
        }
        {
          key = "<C-S-c>";
          mode = [
            "n"
            "v"
          ];
          action = ''[["+y]]'';
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
          key = "<A-t>";
          mode = "n";
          lua = true;
          silent = true;
          action = ''
            function()
              require("conform").format({ lsp_format = "fallback" })
            end
          '';
          noremap = true;
          desc = "Format current buffer";
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
          lsp.enable = true;
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
            cmd = lib.mkForce {
              _type = "lua-inline";
              # expr = "require('devcontainers').lsp_cmd({ '/usr/local/bin/basedpyright-langserver', '--stdio' })";
              expr = "require('devcontainers').lsp_cmd({ 'basedpyright-langserver', '--stdio' })";
            };
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
            cmd = lib.mkForce {
              _type = "lua-inline";
              # expr = "require('devcontainers').lsp_cmd({ '${lib.getexe pkgs.ty}', 'server' })";
              expr = "require('devcontainers').lsp_cmd({ 'ty', 'server' })";

            };
            # cmd = lib.mkDefault [
            #   (lib.getExe pkgs.ty)
            #   "server"
            # ];
            filetypes = [ "python" ];
            root_markers = [
              ".git"
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

        -- Override LSP commands for devcontainer support
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
                  }
                }
              '';
            };
          }
        ];

        mappings = {
          findFiles = "<C-f>";
          liveGrep = "<S-f>";
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

            # Smart shell that auto-targets devcontainers
            shell = {
              _type = "lua-inline";
              expr = ''
                function()

                  -- TODO: If open terminal before devcontainer built, goes to host.
                  local status = require("devcontainer.status").get_status()
                  local containers = status.running_containers

                  if #containers > 0 then
                    local container_id = containers[1].container_id
                    return string.format("docker exec -it -w /workspace %s /bin/zsh", container_id)
                  else
                    return vim.o.shell
                  end
                end
              '';
            };

            # Show container indicator when in container
            # on_open = {
            #   _type = "lua-inline";
            #   expr = ''
            #     function(term)
            #       local status = require("devcontainer.status").get_status()
            #       local containers = status.running_containers
            #
            #       if #containers > 0 then
            #         local container_id = containers[1].container_id
            #         -- vim.wo[term.window].winbar = "🐳 Container: " .. container_id:sub(1, 12)
            #       end
            #     end
            #   '';
            # };
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

      assistant.codecompanion-nvim = {
        enable = true;
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

            # Lua - use luacheck for static analysis
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
        nvim-dev-container = {
          # General/main devcontainer plugin
          package = pkgs.vimUtils.buildVimPlugin {
            pname = "nvim-dev-container";
            version = "2026-02-13";
            src = pkgs.fetchFromGitHub {
              owner = "RobertvdLeeuw";
              repo = "nvim-dev-container-premium-edition";
              rev = "main";
              hash = "sha256-5zo2Gc3nekawkodj47uN7stXZqGiT1DZdldJFnHNgOc=";
            };
          };
          setup = ''
            require("devcontainer").setup {
              autocommands = {
                init = true,
                clean = true,
                update = true,
              },

              container_runtime = "docker",
              disable_recursive_config_search = false,
            }
          '';
        };
        devcontainers-nvim = {
          # For LSP-in-devcontainer stuff
          package = pkgs.vimUtils.buildVimPlugin {
            pname = "devcontainers-nvim";
            version = "2026-02-14";
            src = pkgs.fetchFromGitHub {
              # owner = "jedrzejboczar";
              # repo = "devcontainers.nvim";
              # hash = "sha256-tHwN2x6lMq+KdNMzyccMIIq+C9rvSRb9RKtKg7DxrLk=";

              owner = "RobertvdLeeuw";
              repo = "devcontainers.nvim-premium-edition";
              rev = "master";
              hash = "sha256-twY2Yy4ns+bQY0szjFxLaEB1TpButc8tIV4ByTLCHc4=";
            };

            doCheck = false;
          };
          setup = ''
            require('devcontainers').setup({
              log = { level = 'info' },
              use_docker_exec = true
            })
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
