{ pkgs }:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-lspconfig;
      # config = toLua ''
      #   -- ${builtins.readFile ../plugin/lsp/lua.lua}
      #   -- ${builtins.readFile ../plugin/lsp/python.lua}
      #   -- ${builtins.readFile ../plugin/lsp/nix.lua}
      #   -- ${builtins.readFile ../plugin/lsp/json.lua}
      #   -- ${builtins.readFile ../plugin/lsp/rust.lua}
      #   -- ${builtins.readFile ../plugin/lsp/text.lua}
      # '';
    }
  ];
}
