{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my = {
    enableAlacritty = lib.mkOption {
      type = lib.types.bool;
      default = true;
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
      ./everyday.nix
      ./system-tools.nix
      ./terminal.nix
      ./nvim
      ./shells
      ./gaming.nix
    ];
  };
}
