{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    extraPlugins = {
      nvim-luapad = {
        # Lua REPL
        package = pkgs.vimPlugins.nvim-luapad;
        setup = ''
          require('luapad').setup()
        '';
      };
    };
  };
}
