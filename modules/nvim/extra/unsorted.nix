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
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "rafcamlet";
          version = "0.3.1";
          src = pkgs.fetchFromGitHub {
            owner = "rafcamlet";
            repo = "nvim-luapad";
            rev = "v0.3.1";
            hash = "sha256-B0LG7EUyyXyg6N5BWijMWBNtzeF51Cd9m0gzZ437Huc=";
          };

          doCheck = false;
        };
        setup = ''
          require('luapad').setup()
        '';
      };
    };
  };
}
