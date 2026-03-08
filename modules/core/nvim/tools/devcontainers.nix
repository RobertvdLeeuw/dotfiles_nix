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
            owner = "RobertvdLeeuw";
            repo = "devcontainers.nvim-permium-edition";
            rev = "master";
            hash = "sha256-CSN14dd5FPcrZPEEvQTA+318PTQp8HHF2ZkAYdvt/tA=";
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
        package = pkgs.vimPlugins.netman-nvim;
        setup = ''
          require('netman')
        '';
      };
    };
  };
}
