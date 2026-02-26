{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    # extraPlugins = {
    #   devcontainers-nvim = {
    #     # For LSP-in-devcontainer stuff
    #     package = pkgs.vimUtils.buildVimPlugin {
    #       pname = "devcontainers-nvim";
    #       version = "2026-02-14";
    #       src = pkgs.fetchFromGitHub {
    #         owner = "jedrzejboczar";
    #         repo = "devcontainers.nvim";
    #         rev = "master";
    #         hash = "sha256-tHwN2x6lMq+KdNMzyccMIIq+C9rvSRb9RKtKg7DxrLk=";
    #       };
    #
    #       doCheck = false;
    #     };
    #     setup = /* lua */ ''
    #       require("devcontainers").setup({
    #       	log = { level = "trace" },
    #       })
    #     '';
    #   };
    #
    #   netman-nvim = {
    #     # For devcontainers.nvim
    #     package = pkgs.vimPlugins.netman-nvim;
    #     setup = ''
    #       require('netman')
    #     '';
    #   };
    # };

    # Hotfix for devcontainers.nvim container_is_running bug
    luaConfigPre = /* lua */ ''
      vim.opt.rtp:prepend("/mnt/storage/nc/Personal/Projects/devcontainers.nvim-premium-edition/")

      require("devcontainers").setup({
      	log = { level = "trace" },
      })

      vim.keymap.set({ "n", "i" }, "<A-r>", function()
      	-- Clear the cache for persist modules
      	for k, _ in pairs(package.loaded) do
      		if k:match("^devcontainers") then
      			package.loaded[k] = nil
      		end
      	end

      	-- Re-require your main module
      	require("devcontainers").setup({
      		log = { level = "trace" },
      	})
      	print("Reloaded devcontainers")
      end, { desc = "Reload persist modules" })

      -- Hotfix for devcontainers.nvim container_is_running bug
      -- Changes 'echo' string to {'echo'} table for proper unpack()
      -- local cli = require("devcontainers.cli")
      -- cli.container_is_running = function(workspace_dir)
      -- 	local ok = pcall(cli.exec, workspace_dir, { "echo" })
      -- 	return ok
      -- end
    '';
  };
}
