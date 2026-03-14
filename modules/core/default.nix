{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./codelangs/python.nix
    ./codelangs/rust.nix
    ./system-tools.nix
    ./terminal.nix
    ./nvim
    ./shells
    ./gaming.nix
    ./everyday.nix
  ];

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
    sudoTools = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Import sudo tools only.";
    };
  };
}
