{ config, pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        rebuild = "nixos-rebuild build --use-remote-sudo && clear";
        update = "nixos-rebuild switch --use-remote-sudo && clear";
        cnfnix = "cd /etc/nixos && nvim configuration.nix && cd -";

        todo = "nvim ~/Documents/todo.md";
        books = "nvim ~/Documents/books.txt";

        tr = "tree --gitignore -L 3";

        gadd = "git add .";
        gstat = "git status";
        gcom = "git commit -m ";
        gpush = "git push";
      };
      shellGlobalAliases = {
        nano = "nvim";
      };
      
      initContent = ''
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(fzf --zsh)"
        
        autoload -U compinit
        zmodload zsh/complist
        compinit
        _comp_options+=(globdots)             # Include hidden files.

        zstyle ':completion:*' matcher-list 'm:{a-z}={a-zA-Z}'
        zstyle ':completion:*' list-colors '{(s.:.)LS_COLORS}'
        zstyle ':completion:*' menu no

        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

        bindkey '^I'   complete-word       # tab
        # bindkey '^[[Z' autosuggest-accept  # shift + tab
        bindkey '^[^I' autosuggest-accept  # shift + tab

        clear-terminal() { tput reset; zle redisplay; }
        zle -N clear-terminal
        bindkey '^[l' clear-terminal
        bindkey -M viins '^[l' clear-terminal


        # bindkey '^[[1;5A' history-search-backward
        # bindkey '^[[1;5B' history-search-forward

        bindkey '^[k' history-search-backward
        bindkey '^[j' history-search-forward
        bindkey -M viins '^[k' history-search-backward
        bindkey -M viins '^[j' history-search-forward
      '';
      
      defaultKeymap = "viins";
      
      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        extended = true;
        share = true;
      };
    
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "regexp"
        ];
      };
      
      # plugins = [
      #   {
      #     name = "zsh-autosuggestions";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "zsh-users";
      #       repo = "zsh-autosuggestions";
      #       rev = "v0.7.0";
      #       sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
      #     };
      #   }
      # ];
      
      autosuggestion = {
        enable = true;
        # highlight = "fg=8"; 
      };
    };
    
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
