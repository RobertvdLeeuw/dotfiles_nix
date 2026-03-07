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

    gettext
    unzip
    zip
    file

    git

    docker-compose
    docker
    # nix-fast-build

    p7zip

    git
  ];
}
