{ config, pkgs, ... }:
{
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      python313
      jupyter
      uv
      #  TODO: UV2Nix
    ];
  };
}
