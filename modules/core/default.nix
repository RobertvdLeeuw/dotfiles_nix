{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my = {
    noGUI = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Alacritty (GUI terminal editor)";
    };
    noAI = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable AI tools.";
    };
  };

  config = {
    imports = [
      ./codelangs/python.nix
      ./codelangs/rust.nix
      ./system-tools.nix
      ./terminal.nix
      ./nvim
      ./shells
    ]
    ++ lib.optionals (!config.my.noGUI) [
      ./gaming.nix
      ./everyday.nix
    ];
  };
}
