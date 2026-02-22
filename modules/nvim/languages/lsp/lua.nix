{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      lspSignature.enable = false; # Using blink-cmp
      servers = {
        lua-language-server = {
          # cmd = lib.mkForce {
          #   _type = "lua-inline";
          #   expr = "lua-language-server";
          # };
          cmd = lib.mkDefault [
            (lib.getExe pkgs.lua-language-server)
          ];

          filetypes = [ "lua" ];
          root_markers = [
            ".luarc.json"
            ".luarc.jsonc"
            ".luacheckrc"
            ".stylua.toml"
            ".git"
          ];

          settings.Lua = {
            runtime = {
              version = "LuaJIT";
            };

            diagnostics = {
              globals = [ "vim" ];
              disable = [
                "unused-local"
                "redefined-local"
              ];
            };
          };
        };
      };
    };
  };
}
