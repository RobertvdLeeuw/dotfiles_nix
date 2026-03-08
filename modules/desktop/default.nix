{
  config,
  pkgs,
  pkgs-ollama,
  inputs,
  ...
}:
{
  imports = [
    ./sway/sway-home.nix
    ./wofi/wofi.nix
    ./waybar/waybar.nix
    ./ai/aitools.nix
  ];
}
