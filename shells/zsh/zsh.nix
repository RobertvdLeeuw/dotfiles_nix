{ config, pkgs, ... }:

{
	programs = {
    zsh = {
      enable = true;
      shellAliases = {  # TODO: To separate file, share accross shells?
        rebuild = "nixos-rebuild build --use-remote-sudo";
        update = "nixos-rebuild switch --use-remote-sudo";

        cnfnix = "cd /etc/nixos && sudo nvim configuration.nix && cd -";
        cnfhome = "cd /mnt/storage/nc/Personal/dotfiles/home-manager && nvim home.nix && cd -";
        cnfvim = "cd /mnt/storage/nc/Personal/dotfiles/home-manager && nvim nvim/nvim.nix && cd -";

        # dv = "find ./src/ && fd --type f --exclude __pycache__ | fzf -q src/ | xargs -r nvim";
        todo = "nvim ~/Documents/todo.md";
        books = "nvim ~/Documents/books.txt";
      };

      shellGlobalAliases = {
        nano = "nvim";
      };
      
      initContent = ''
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(fzf --zsh)"
        
        ${builtins.readFile ./init.sh}
        ${builtins.readFile ./prompt.sh}
      '';

        # builtins.readFile ../shells/zsh/init.sh;  # Split hotkeys into separate file?
      # plugins = [{}];

      defaultKeymap = "viins";
      history = {
        
      };
    
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "regexp"
        ];
      };

      zplug = {
        enable = true;
        # plugins = [];
      };
      
      autosuggestion = {
        enable = true;
        # highlight = "";
      };
    };
	};
}
