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
    GUI = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GUI tools.";
    };
    AI-tools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable AI tools.";
    };
    sudoTools = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Import sudo tools only.";
    };
  };
}
