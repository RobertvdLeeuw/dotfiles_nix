{ config, pkgs, inputs, ... }:
{
  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";

      ui-plugins = import ./plugin/nix/ui.nix { inherit pkgs; };
      editor-plugins = import ./plugin/nix/editor.nix { inherit pkgs; };
      lsp-plugins = import ./plugin/nix/lsp.nix { inherit pkgs; };
      completion-plugins = import ./plugin/nix/completion.nix { inherit pkgs; };
      navigation-plugins = import ./plugin/nix/filenav.nix { inherit pkgs; };
    in
      {
      enable = true;
      defaultEditor = true;
      extraLuaConfig = ''
        ${builtins.readFile ./init.lua}


    -- Style
        ${builtins.readFile ./style/general.lua}

    -- Keymaps
        ${builtins.readFile ./keymaps/general.lua}
        ${builtins.readFile ./keymaps/tabs.lua}
        ${builtins.readFile ./keymaps/editor.lua}
        ${builtins.readFile ./keymaps/file_explorer.lua}
      '';

      extraPackages = with pkgs; [
        ruff
        # ty

        rust-analyzer
        rustfmt

        # nil  # Nix
        # vscode-langservers-extracted  # Jsonls
        # lua-language-server
      ] ++
        # ui-plugins.extraPackages ++
        # editor-plugins.extraPackages ++
        # lsp-plugins.extraPackages ++
        # completion-plugins.extraPackages ++
        navigation-plugins.extraPackages;

      plugins = 
        ui-plugins.plugins ++
        editor-plugins.plugins ++
        lsp-plugins.plugins ++
        completion-plugins.plugins ++
        navigation-plugins.plugins;
    };
}
