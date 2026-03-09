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

    docker-compose
    docker
    # nix-fast-build

    sops

    p7zip
  ];
}
