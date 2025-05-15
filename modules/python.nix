{ config, pkgs, ... }:
{
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      python313
      jupyter

      #  TODO: UV2Nix
    ];
  };
}
