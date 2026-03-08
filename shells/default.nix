{ config, pkgs, ... }:
{
  imports = [ ./zsh.nix ];
  home = {
    packages = with pkgs; [
      any-nix-shell # for nix-shell in zsh. I don't like bash. No. Stop it.
    ];

    shellAliases = {
      update = "cd /etc/nixos; sudo nix flake update; sudo nixos-rebuild switch --flake --sudo --impure && clear; cd -";
      updatev = "cd /etc/nixos; sudo nix flake update; sudo nixos-rebuild switch --show-trace --flake --sudo --impure && clear; cd -"; # Verbose
      cnfnix = "cd /etc/nixos && nvim flake.nix && cd -";
      try = "nix-shell -p";

      todo = "nvim ~/Documents/todo.md";
      books = "nvim ~/Documents/books.txt";

      tr = "tree --gitignore -L 3 -a -I .git/ -I __pycache__/ -I target/";

      ga = "git add . && clear";
      gs = "git status";
      gc = "oco --context ";
      gcm = "git commit -m ";
      gp = "git push && clear";

      dumb = "aichat -e";

      cat = "bat";
    };
  };
  programs.bash = {
    enable = true;
    initExtra = /* sh */ ''
      eval "$(starship init bash)"
    '';
  };
}
