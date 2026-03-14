{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    wget
    jq
    which
    bluetuith

    gettext
    unzip
    zip
    file

    git
    gnumake

    docker-compose
    docker
    # nix-fast-build

    sops

    p7zip
  ];
}
