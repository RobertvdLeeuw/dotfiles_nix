{
  pkgs,
  lib,
  ...
}:

/*
  TODO
  - devcontainer
    - Fix start, terminal connect
    - open issue
    - Re-enable LSPs
    - Fix opencommit
      - Give high level notes
  - Agent stuff
    - CodeCompanion

  - https://github.com/jbyuki/nabla.nvim (render-markdown.setup(o attach/initial/render))
  - https://github.com/mluders/comfy-line-numbers.nvim
  - otter.nvim if I ever need LSPs for embedded languages.
  - Linters for embedded langs
  - Change file formatting rules
  - Borders
    - gl, gk
    - autocomp
  - Folding behavior
    - https://github.com/kevinhwang91/nvim-ufo
    - Auto on file open
    - no nest beyond func/meth bodies
  - Something debugger
  - Test integration https://www.youtube.com/watch?v=cf72gMBrsI0
*/

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
    (import ./languages/lsp/lua.nix { inherit pkgs lib; })
    (import ./tools/telescope.nix { inherit pkgs lib; })
    (import ./tools/filenav.nix { inherit pkgs lib; })
    (import ./tools/terminal.nix { inherit pkgs lib; })
    (import ./tools/devcontainers.nix { inherit pkgs lib; })
    (import ./extra/unsorted.nix { inherit pkgs lib; })
    (import ./ai/codecompanion.nix { inherit pkgs lib; })
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

  home.packages = [ pkgs.devcontainer ];
}
