{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    extraPlugins = {
      sops-nvim = {
        # For LSP-in-devcontainer stuff
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "sops-nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "trixnz";
            repo = "sops.nvim";
            rev = "master";
            hash = "sha256-SXlI2M2BjNKEbReqTnNXITmryAboPjQJmq1IcgAMc5A=";
          };
        };
      };
    };
  };
}
