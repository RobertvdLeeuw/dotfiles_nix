{ pkgs }:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  plugins = with pkgs.vimPlugins; [
    {
      plugin = hardtime-nvim;
      config = toLua ''
        require("hardtime").setup({
          disable_mouse = false
        })
      '';
    }
    {
      plugin = toggleterm-nvim;
      config = toLuaFile ../lua/toggleterm.lua;
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
    # { plugin = injectme; }
    # { plugin = nabla-nvim; }
    {
      plugin = (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-vim
        p.tree-sitter-latex
        p.tree-sitter-bash
        p.tree-sitter-lua
        p.tree-sitter-python
        p.tree-sitter-markdown
        p.tree-sitter-rust
      ]));
      config = toLuaFile ../lua/treesitter.lua;
    }
  ];
}

