{
  pkgs,
  lib,
  ...
}:
{
  settings.vim = {
    utility = {
      yazi-nvim = {
        enable = true;

        setupOpts = {
          config_home = "/etc/nixos/modules/nvim/plugin/yazi/";

          open_for_directories = true;
          yazi_floating_window_border = "none";
          floating_window_scaling_factor = 1;

          keymaps = {
            show_help = "<f1>";

            # Disable other keymaps
            open_file_in_vertical_split = false;
            open_file_in_horizontal_split = false;
            open_file_in_tab = false;
            grep_in_directory = false;
            replace_in_directory = false;
            cycle_open_buffers = false;
            copy_relative_path_to_selected_files = false;
            send_to_quickfix_list = false;
          };
        };
      };
    };

    navigation.harpoon = {
      enable = true;
      mappings = {
        file1 = "<A-1>";
        file2 = "<A-2>";
        file3 = "<A-3>";
        file4 = "<A-4>";

        listMarks = "<A-Space>";
        markFile = "<A-m>";
      };
    };
  };
}
