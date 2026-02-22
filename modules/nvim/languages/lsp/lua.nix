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

            workspace = {
              library = lib.generators.mkLuaInline ''
                vim.api.nvim_get_runtime_file("", true)
              '';
              checkThirdParty = false;
            };

            diagnostics = {
              # globals = [ "vim" ];
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
