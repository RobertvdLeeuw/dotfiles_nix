{
  config,
  pkgs,
  inputs,
  ...
}:

{
  programs.starship = {
    enable = true;

    # Hardcoded colors (HEX) so nvim theme doesn't remap colors and fuck up the looks.
    settings = {
      format = "┌$username$directory$git_branch$nix_shell$shell\n$character";
      line_break = true;
      add_newline = false;

      character = {
        success_symbol = "└─";
        error_symbol = "└─";
      };

      username = {
        style_user = "bold #90b99f";
        style_root = "bold #ca1444";
        format = "──\\[[$user]($style)\\]";
        show_always = false;
        disabled = false;
      };

      directory = {
        format = "──\\[[$path](bold #cb6fa1)\\]";
        truncation_length = 4;
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };

      git_branch = {
        format = "──\\[[$branch](bold #aca1cf)\\]";
      };

      nix_shell = {
        format = "──\\[[nix](bold #90b99f)\\]";
      };

      shell = {
        bash_indicator = "──\\[[bash](bold #e8a831)\\]";
        zsh_indicator = "";
        disabled = false;
        format = "$indicator";
      };
    };
  };
}
