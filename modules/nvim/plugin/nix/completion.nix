{ pkgs }:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  plugins = with pkgs.vimPlugins; [
    luasnip
    {
      plugin = nvim-cmp;
      config = toLuaFile ../lua/cmp.lua;
    }
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-cmdline
  ];
}

