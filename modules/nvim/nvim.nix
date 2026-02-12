{
  # config,
  pkgs,
  # inputs,
  lib,
  ...
}:

/*
  TODO
  - Nested language support
  - Theme colors
  - Colored autocomp
  - More color coding in text
  - Change formatting rules
  - Rainbow brackets
  - Agent stuff
  - devcontainer
    - sync LSP/TS errors with devcontainer (no "package not found" by looking in the wrong place)
    - Direnv kinda thing
  - Something debugger
*/

{
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        name = "oxocarbon";
      };

      visuals = {
        rainbow-delimiters.enable = true;
        cinnamon-nvim.enable = true;
        highlight-undo.enable = true;
        nvim-cursorline = {
          enable = true;
          setupOpts.cursorword.enable = true;
        };
      };

      ui = {
        colorizer.enable = true;
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

      options = {
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
        bash.enable = true;
        # html.enable = true;
        lua.enable = true;
        python.enable = true;
        rust.enable = true;
        sql.enable = true;
        json.enable = true;
        nix.enable = true;
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
          ty = {
            cmd = lib.mkDefault [
              (lib.getExe pkgs.ty)
              "server"
            ];
            filetypes = [ "python" ];
            root_markers = [
              ".git"
              "pyproject.toml"
              "setup.cfg"
              "requirements.txt"
              "Pipfile"
              "pyrightconfig.json"
            ];

            # If your LSP accepts custom settings. See `:help lsp-config` for more details
            # on available fields. This is a freeform field.
            # settings.ty = {
            # };
          };
        };
      };

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

          completion.documentation.auto_show_delay_ms = 200;

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
            focusable = false;
            style = "minimal";
            border = "rounded";
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

      extraPlugins = {
        yazi-nvim = {
          package = pkgs.vimPlugins.yazi-nvim;
          setup = ''
            require("yazi").setup({
              open_for_directories = true,

              yazi_floating_window_border = "none",
              floating_window_scaling_factor = 1,

              keymaps = {
                show_help = "<f1>",

                -- Disable other keymaps
                open_file_in_vertical_split = false,
                open_file_in_horizontal_split = false,
                open_file_in_tab = false,
                grep_in_directory = false,
                replace_in_directory = false,
                cycle_open_buffers = false,
                copy_relative_path_to_selected_files = false,
                send_to_quickfix_list = false,
              },
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
