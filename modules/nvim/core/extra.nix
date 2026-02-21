{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    clipboard = {
      enable = true;
      providers.wl-copy.enable = true;
      registers = "unnamedplus";
    };

    autopairs.nvim-autopairs.enable = true;

    comments.comment-nvim = {
      enable = true;
      mappings = {
        toggleCurrentLine = "<C-c>";
        toggleSelectedLine = "<C-c>";
      };
    };
  };
}
