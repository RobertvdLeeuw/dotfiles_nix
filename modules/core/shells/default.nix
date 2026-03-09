{
  config,
  pkgs,
  lib,
  hostType,
  ...
}:
{
  imports = [ ./zsh.nix ];
  home = {
    packages = with pkgs; [
      any-nix-shell # for nix-shell in zsh. I don't like bash. No. Stop it.
    ];

    shellAliases = lib.mkMerge [
      {
        cnfnix = "cd /etc/nixos && nvim flake.nix && cd -";
        try = "nix-shell -p";

        update = ''
          cd /etc/nixos
          sudo nix flake update
          sudo nixos-rebuild switch \
            --flake .#${hostType} \
            --sudo --impure --show-trace && clear
          cd -
        '';

        todo = "nvim ~/Documents/todo.md";
        books = "nvim ~/Documents/books.txt";

        tr = "tree --gitignore -L 3 -a -I .git/ -I __pycache__/ -I target/";

        ga = "git add . && clear";
        gs = "git status";

        gcm = "git commit -m ";
        gp = "git push && clear";

        cat = "bat";
      }

      (lib.mkIf (hostType == "desktop") {
        dumb = "aichat -e";
        gc = "oco --context ";
      })

      (lib.mkIf (hostType == "laptop") {
        gc = "echo 'Opencommit not set up.'";
      })
    ];
  };
  programs.bash = {
    enable = true;
    initExtra = /* sh */ ''
      eval "$(starship init bash)"
    '';
  };
}
