{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    options = {
      foldlevel = 20;
      foldlevelstart = 20;
      foldnestmax = 8;
      tabstop = 2;
      shiftwidth = 2;
    };

    autocmds = [
      {
        event = [
          "BufWinLeave"
          "BufWritePost"
          "WinLeave"
        ];
        pattern = [ "*" ];
        callback = lib.generators.mkLuaInline /* lua */ ''
          function(args)
            if vim.b[args.buf].view_activated then
              vim.cmd.mkview { mods = { emsg_silent = true } }
            end
          end
        '';
        desc = "Save view with mkview for real files";
      }
      {
        event = [ "BufWinEnter" ];
        pattern = [ "*" ];
        callback = lib.generators.mkLuaInline /* lua */ ''
          function(args)
            if not vim.b[args.buf].view_activated then
              local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
              local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
              local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
              if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
                vim.b[args.buf].view_activated = true
                vim.cmd.loadview { mods = { emsg_silent = true } }
              end
            end
          end
        '';
        desc = "Try to load file view if available and enable view saving for real files";
      }
    ];
  };
}
