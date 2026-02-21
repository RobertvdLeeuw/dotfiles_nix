{
  pkgs,
  lib,
  ...
}:
let
  # Import all modules as a list
  modules = [
    (import ./core/options.nix { inherit pkgs lib; })
    (import ./core/keymaps.nix { inherit pkgs lib; })
    (import ./core/extra.nix { inherit pkgs lib; })
    (import ./ui/visuals.nix { inherit pkgs lib; })
    (import ./ui/statusline.nix { inherit pkgs lib; })
    (import ./ui/extra.nix { inherit pkgs lib; })
    (import ./languages/languages.nix { inherit pkgs lib; })
    (import ./languages/completion.nix { inherit pkgs lib; })
    (import ./languages/formatting.nix { inherit pkgs lib; })
    (import ./languages/diagnostics.nix { inherit pkgs lib; })
    (import ./languages/lsp/python.nix { inherit pkgs lib; })
    (import ./tools/telescope.nix { inherit pkgs lib; })
    (import ./tools/filenav.nix { inherit pkgs lib; })
    (import ./tools/terminal.nix { inherit pkgs lib; })
    (import ./tools/devcontainers.nix { inherit pkgs lib; })
    (import ./ai/codecompanion.nix { inherit pkgs lib; })
    (import ./ai/persistence.nix { inherit pkgs lib; })
    (import ./extra/unsorted.nix { inherit pkgs lib; })
  ];

  # Extract and concatenate lua configs from all modules
  extractLuaConfigs =
    configName:
    let
      configs = lib.filter (s: s != "") (
        map (m: lib.attrByPath [ "settings" "vim" configName ] "" m) modules
      );
    in
    lib.concatStringsSep "\n\n" configs;

  # Remove lua config fields from a module to prevent merge conflicts
  removeLuaConfigs =
    module:
    if module ? settings && module.settings ? vim then
      module
      // {
        settings = module.settings // {
          vim = builtins.removeAttrs module.settings.vim [
            "luaConfigPre"
            "luaConfigRC"
            "luaConfigPost"
          ];
        };
      }
    else
      module;

  # Clean all modules by removing lua config fields
  cleanedModules = map removeLuaConfigs modules;
in
{
  programs.nvf = lib.mkMerge (
    [
      # Enable nvf
      { enable = true; }

      # Consolidated lua configs from all modules
      {
        settings.vim = {
          luaConfigPre = extractLuaConfigs "luaConfigPre";
          luaConfigPost = extractLuaConfigs "luaConfigPost";
        };
      }
    ]
    ++ cleanedModules
  );
}
