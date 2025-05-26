{ config, pkgs, inputs, ... }:
{
  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";

      neocodeium = pkgs.vimUtils.buildVimPlugin {
        name = "neocodeium";
        src = pkgs.fetchFromGitHub {
          owner = "monkoose";
          repo = "neocodeium";
          rev = "09267a754f4133b1e06e83da5d58ba455fac3b93";
          hash = "sha256-p7JH7SxRE/VYINJvU0b0u5H0HPlWH/lE6mLgiqQTMzM=";
        };
        
        doCheck = false;
      };

      injectme = pkgs.vimUtils.buildVimPlugin {
        name = "injectme";
        src = pkgs.fetchFromGitHub {
          owner = "Dronakurl";
          repo = "injectme.nvim";
          rev = "2aea7ad8c4b137ff8809586ca65784e7e5651c8c";
          hash = "sha256-XDZ1JvcsS/Of7NhGJ7Q5XiSUf/GvulZgEOwKP/Oabxg=";
        };        
        doCheck = false;
      };
    in
      {
      enable = true;
      defaultEditor = true;
      extraLuaConfig = ''
        ${builtins.readFile ./init.lua}


    -- Style
        ${builtins.readFile ./style/general.lua}

    -- Keymaps
        ${builtins.readFile ./keymaps/general.lua}
        ${builtins.readFile ./keymaps/tabs.lua}
        ${builtins.readFile ./keymaps/editor.lua}
        ${builtins.readFile ./keymaps/file_explorer.lua}
      '';

      extraPackages = with pkgs; [
        basedpyright
        ruff

        rust-analyzer
        rustfmt

        nil  # Nix
        vscode-langservers-extracted  # Jsonls
        lua-language-server

        ripgrep  # For Telescope
        ranger  # File Explorer
      ];

      plugins = with pkgs.vimPlugins; [
        # TODO
        # Editor stuff
        # null-ls-nvim
        {
          plugin = astrotheme;
          config = toLua ''
        require("astrotheme").setup()
        vim.cmd([[colorscheme astrodark]])
          '';
        }
        # {
        #   plugin = mellow-theme;
        #   config = toLua ''
        #   vim.cmd([[colorscheme mellow]])
        #   '';
        # }
        {
          plugin = ranger-nvim;
          config = toLua ''
            require("ranger-nvim").setup({ replace_netrw = true, enable_cmds = true })
          '';
        }
        {
          plugin = hardtime-nvim;
          config = toLua ''
            require("hardtime").setup({
              disable_mouse = false
            })
          '';
        }
        {
          plugin = nvim-colorizer-lua;
          config = toLua ''
            require('colorizer').setup()
          '';
        }
        {
          plugin = toggleterm-nvim;
          config = toLuaFile ./plugin/toggleterm.lua;
        }
        {
          plugin = nvim-comment;
          config = toLua ''
          require("nvim_comment").setup({
            create_mappings = false,
            comment_empty = false
          })
          '';
        }

        # {
        #   plugin = neocodeium;
        #   config = toLua ''
        #     local neocodeium = require('neocodeium')
        #     neocodeium.setup({manual = false})
        #   -- vim.keymap.set("i", "<A-Tab>", function() neocodeium.accept() end)

        #     vim.api.nvim_create_autocmd("User", {
        #       pattern = "NeoCodeiumCompletionDisplayed",
        #       callback = function() require("cmp").abort() end
        #     })

        #   -- set up some sort of keymap to cycle and complete to trigger completion
        #     vim.keymap.set("i", "<A-e>", function() neocodeium.cycle_or_complete() end)
        #   -- make sure to have a mapping to accept a completion
        #     vim.keymap.set("i", "<A-f>", function() neocodeium.accept() end)


        #   -- Function to determine if we should use cmp or neocodeium
        #     local function should_use_cmp()
        #     local col = vim.fn.col('.') - 1
        #     local line = vim.fn.getline('.')
        #     local char_before = line:sub(col, col)
            
        #     -- If we're at the beginning of a line or after whitespace/punctuation,
        #     -- prefer neocodeium
        #     if col == 0 or char_before:match('%s') or char_before:match('[%.,%(%)%:%;%=%+%-%*%/%[%]%{%}]') then
        #       return false
        #     end
            
        #     -- Otherwise (in the middle of a word), prefer cmp
        #     return true
        #   end

        #   -- Set up autocommands to toggle between the two systems
        #   vim.api.nvim_create_autocmd({"InsertCharPre", "TextChangedI"}, {
        #     callback = function()
        #       if should_use_cmp() then
        #         neocodeium.disable()
        #         -- You might need a way to "enable" cmp if you've set autocomplete = false
        #         -- This might be through a global variable that your mappings check
        #         vim.g.cmp_active = true
        #       else
        #         neocodeium.enable()
        #         vim.g.cmp_active = false
        #       end
        #     end
        #   })

        #   '';
        # }

        # Semantic highlighting
        {
          plugin = todo-comments-nvim;
          config = toLua "require('todo-comments').setup({ signs = false })";
        }
        {
          plugin = rainbow-delimiters-nvim;
          config = toLua ''
          require('rainbow-delimiters.setup').setup{
            highlight = {
                'RainbowDelimiterRed',
                'RainbowDelimiterYellow',
                'RainbowDelimiterBlue',
                'RainbowDelimiterOrange',
                'RainbowDelimiterGreen',
                'RainbowDelimiterViolet',
                'RainbowDelimiterCyan',
            },
          }
          '';
        }
        { plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-markdown
          p.tree-sitter-rust
        ]));
          config = toLuaFile ./plugin/treesitter.lua;
        }
        {
          plugin = injectme;
        }
        {
          plugin = lualine-nvim;
          config = toLua "require('lualine').setup()";
        }
        # TODO: Nabla and MD render

        # File explorer
        {
          plugin = telescope-nvim;
          config = toLuaFile ./plugin/telescope.lua;
        }
        telescope-fzf-native-nvim

        # Autocomplete
        luasnip
        {
          plugin = nvim-cmp;
          config = toLuaFile ./plugin/cmp.lua;
        }
        cmp-nvim-lsp
        {
          plugin = nvim-lspconfig;
          # ${builtins.readFile ./plugin/lsp/general.lua}
          config = toLua ''
            ${builtins.readFile ./plugin/lsp/lua.lua}
            ${builtins.readFile ./plugin/lsp/python.lua}
            ${builtins.readFile ./plugin/lsp/nix.lua}
            ${builtins.readFile ./plugin/lsp/json.lua}
            ${builtins.readFile ./plugin/lsp/rust.lua}
            ${builtins.readFile ./plugin/lsp/text.lua}
          '';
        }
        cmp-buffer
        cmp-path
        cmp-cmdline

        # Other
        {
          plugin = nvim-autopairs;
          config = toLua ''
          require('nvim-autopairs').setup({
            enable_check_bracket_line = false
          })

          local cmp_autopairs = require('nvim-autopairs.completion.cmp')
          local cmp = require('cmp')
          cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
          )
          '';
        }
        {
          plugin = render-markdown-nvim;
          config = toLua ''
            require('render-markdown').setup({
              completions = { lsp = { enabled = true } },
            })
          '';
        }
        # {
        #   plugin = ;
        #   config = toLua '''';
        # }

        # {
        #       plugin = auto-session;
        #       config = toLua ''
        #         require(\"auto-session\").setup({
        #           log_level = "error",
        # 		  auto_session_suppress_dirs = { "~/", "~/Downloads" },
        # 	  })
        #       '';
        #     }
      ];

    };
}
