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
        basedpyright = {
          cmd = lib.mkForce {
            _type = "lua-inline";
            expr = "require('devcontainers').lsp_cmd({ 'basedpyright-langserver', '--stdio' })";
          };

          filetypes = [ "python" ];
          root_markers = [
            "pyproject.toml"
            "setup.cfg"
            "requirements.txt"
            "Pipfile"
            "pyrightconfig.json"
          ];

          settings.basedpyright = {
            analysis = {
              diagnosticSeverityOverrides = {
                reportAny = "none";
                reportUnknownMemberType = "none";
                reportUnknownVariableType = "none";
                reportMissingImports = "none"; # Handled by ty.
              };
            };
          };
        };

        ty = {
          cmd = lib.mkForce {
            _type = "lua-inline";
            expr = "require('devcontainers').lsp_cmd({ 'ty', 'server' })";
          };

          filetypes = [ "python" ];
          root_markers = [
            "pyproject.toml"
            "setup.cfg"
            "requirements.txt"
            "Pipfile"
            "pyrightconfig.json"
          ];

          settings.ty = {
            configuration = {
              rules = lib.generators.mkLuaInline ''{ ["unresolved-reference"] = "ignore" }'';
            };
          };
        };
      };
    };
  };
}
