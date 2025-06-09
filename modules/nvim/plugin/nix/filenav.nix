{ pkgs }:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  extraPackages = with pkgs; [
    ripgrep
    ranger
  ];

  plugins = with pkgs.vimPlugins; [
    {
      plugin = ranger-nvim;
      config = toLua ''
        require("ranger-nvim").setup({ replace_netrw = true, enable_cmds = true })
      '';
    }
    {
      plugin = telescope-nvim;
      config = toLuaFile ../lua/telescope.lua;
    }
    telescope-fzf-native-nvim
  ];
}
