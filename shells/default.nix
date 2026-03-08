{
  config,
  pkgs,
  lib,
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

        todo = "nvim ~/Documents/todo.md";
        books = "nvim ~/Documents/books.txt";

        tr = "tree --gitignore -L 3 -a -I .git/ -I __pycache__/ -I target/";

        ga = "git add . && clear";
        gs = "git status";

        gcm = "git commit -m ";
        gp = "git push && clear";

        cat = "bat";
      }

      (lib.mkIf (config.networking.hostName == "nixos") {
        update = /* sh */ ''
          cd /etc/nixos
          sudo nix flake update
          sudo nixos-rebuild switch --flake /etc/nixos#desktop --sudo --impure && clear
          cd -
        '';

        # Verbose
        updatev = /* sh */ ''
          cd /etc/nixos
          sudo nix flake update
          sudo nixos-rebuild switch --show-trace --flake /etc/nixos#desktop --sudo --impure && clear
          cd -
        '';

        dumb = "aichat -e";
        gc = "oco --context ";
      })

      (lib.mkIf (config.networking.hostName == "nixos-lt") {
        update = /* sh */ ''
          cd /etc/nixos
          sudo nix flake update
          sudo nixos-rebuild switch --flake /etc/nixos#laptop --sudo --impure && clear
          cd -
        '';

        # Verbose
        updatev = /* sh */ ''
          cd /etc/nixos
          sudo nix flake update
          sudo nixos-rebuild switch --show-trace --flake /etc/nixos#laptop --sudo --impure && clear
          cd -
        '';

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
