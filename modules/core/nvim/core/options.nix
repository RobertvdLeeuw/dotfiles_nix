{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    options = {
      foldlevel = 20;
      foldlevelstart = 2;
      foldnestmax = 8;
      tabstop = 2;
      shiftwidth = 2;
    };

    # autocmds = [
    #   {
    #     event = [ "BufReadPost" ];
    #     pattern = [ "*" ];
    #     command = "normal zR";
    #     desc = "Open all folds when reading a file";
    #   }
    # ];
  };
}
