{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    extraPlugins = {
      devcontainers-nvim = {
        # For LSP-in-devcontainer stuff
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "devcontainers-nvim";
          version = "2026-02-14";
          src = pkgs.fetchFromGitHub {
            owner = "jedrzejboczar";
            repo = "devcontainers.nvim";
            rev = "master";
            hash = "sha256-tHwN2x6lMq+KdNMzyccMIIq+C9rvSRb9RKtKg7DxrLk=";
          };

          doCheck = false;
        };
        setup = /* lua */ ''
          require("devcontainers").setup({
          	log = { level = "trace" },
          })
        '';
      };

      netman-nvim = {
        # For devcontainers.nvim
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "netman-nvim";
          version = "2026-02-14";
          src = pkgs.fetchFromGitHub {
            owner = "miversen33";
            repo = "netman.nvim";
            rev = "master";
            hash = "sha256-SmpAuhDM764kT8BG1XWztNt3CJITohhrGoaB3DBo0U0=";
          };

          doCheck = false;
        };
        setup = ''
          require('netman')
        '';
      };
    };

    # Hotfix for devcontainers.nvim container_is_running bug
    luaConfigPost = /* lua */ ''
      -- Hotfix for devcontainers.nvim container_is_running bug
      -- Changes 'echo' string to {'echo'} table for proper unpack()
      local cli = require("devcontainers.cli")
      cli.container_is_running = function(workspace_dir)
      	local ok = pcall(cli.exec, workspace_dir, { "echo" })
      	return ok
      end
    '';
  };
}
