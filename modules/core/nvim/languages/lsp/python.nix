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
          cmd = lib.mkForce (
            lib.mkLuaInline /* lua */ ''
              require("devcontainers").lsp_cmd(function(config)
              	local manager = require("devcontainers.manager")
              	if manager.is_workspace_dir(config.root_dir) then
              		return { "basedpyright-langserver", "--stdio", "--verbose" }
              	else
              		return { "${lib.getExe' pkgs.basedpyright "basedpyright-langserver"}", "--stdio" }
              	end
              end)
            ''
          );

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
          cmd = lib.mkForce (
            lib.mkLuaInline /* lua */ ''
              require("devcontainers").lsp_cmd(function(config)
              	local manager = require("devcontainers.manager")
              	if manager.is_workspace_dir(config.root_dir) then
              		return { "ty", "server" }
              	else
              		return { "${lib.getExe pkgs.ty}", "server" }
              	end
              end)
            ''
          );

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
