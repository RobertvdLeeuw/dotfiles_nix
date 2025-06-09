{ pkgs }:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  plugins = with pkgs.vimPlugins; [
    { plugin = astrotheme;
      config = toLua ''
        require("astrotheme").setup()
        vim.cmd([[colorscheme astrodark]])
      '';
    }
    # { plugin = mellow-theme;
    #   config = toLua ''
    #   vim.cmd([[colorscheme mellow]])
    #   '';
    # }
    { plugin = lualine-nvim;
      config = toLua "require('lualine').setup()";
    }
    { plugin = nvim-colorizer-lua;
      config = toLua ''
        require('colorizer').setup()
      '';
    }
    { plugin = rainbow-delimiters-nvim;
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
    { plugin = todo-comments-nvim;
      config = toLua "require('todo-comments').setup({ signs = false })";
    }
    { plugin = render-markdown-nvim;
      config = toLua ''
        require('render-markdown').setup({
          completions = { lsp = { enabled = true } },
        })
      '';
    }
  ];
}
