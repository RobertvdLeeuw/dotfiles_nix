{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    python313
    jupyter
    # marimo
    uv
  ];
}
