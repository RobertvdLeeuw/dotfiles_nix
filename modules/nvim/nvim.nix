{ config, pkgs, inputs, ... }:
{
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     vimPlugins = prev.vimPlugins // {
  #       mellow-theme = prev.vimUtils.buildVimPlugin {
  #         name = "mellow";
  #         src = inputs.plugin-mellow;
  #       };
  #     };
  #   })
  # ];

  programs.neovim =
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
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
      nnn  # File Explorer
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
        plugin = nnn-vim;
        config = toLua ''
        require('nnn').setup({
          replace_netrw = true,
          command = "nnn -H"
        })

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
