{ config, pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        # rebuild = "sudo nixos-rebuild build --use-remote-sudo --impure && clear";
        update = "cd /etc/nixos; sudo nix flake update; sudo nixos-rebuild switch --flake --sudo --impure && clear; cd -";
        cnfnix = "cd /etc/nixos && nvim configuration.nix && cd -";
        cnfnixr = "cd /etc/nixos && nvim README.md && cd -";
        try = "nix-shell -p";

        todo = "nvim ~/Documents/todo.md";
        books = "nvim ~/Documents/books.txt";

        tr = "tree --gitignore -L 3 -a -I .git/";

        ga = "git add . && clear";
        gs = "git status";
        gc = "oco";
        gp = "git push && clear";
      };
      shellGlobalAliases = {
        # man = "wikiman";
        cat = "bat";
        nano = "nvim";
        surf = "GDK_BACKEND=x11 surf"; # TODO: Better fix for this, surf + xwayland = :()
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
        bindkey '^[[Z' forward-word  # shift + tab
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

        eval "$(direnv hook zsh)"

        export NIXPKGS_ALLOW_UNFREE=1
        # Declare the ZSH_HIGHLIGHT_STYLES array for syntax highlighting color overrides
        # typeset -a zsh_highlight_styles
        #
        # # Hardcoded colors so nvim theme doesn't fuck things up
        # zsh_highlight_styles[unknown-token]='fg=#ca1444'
        # zsh_highlight_styles[reserved-word]='fg=#cb6fa1,bold'
        # zsh_highlight_styles[alias]='fg=#aca1cf'
        # zsh_highlight_styles[builtin]='fg=#e8a831'
        # zsh_highlight_styles[function]='fg=#90b99f'
        # zsh_highlight_styles[command]='fg=#90b99f'
        # zsh_highlight_styles[precommand]='fg=#e8a831,underline'
        # zsh_highlight_styles[commandseparator]='fg=#c9c7cd'
        # zsh_highlight_styles[hashed-command]='fg=#90b99f'
        # zsh_highlight_styles[path]='fg=#aca1cf'
        # zsh_highlight_styles[path_prefix]='fg=#aca1cf,underline'
        # zsh_highlight_styles[globbing]='fg=#b9aeda'
        # zsh_highlight_styles[history-expansion]='fg=#cb6fa1,bold'
        # zsh_highlight_styles[command-substitution]='fg=#282828,bg=#e8a831'
        # zsh_highlight_styles[command-substitution-delimiter]='fg=#e8a831'
        # zsh_highlight_styles[process-substitution]='fg=#282828,bg=#e8a831'
        # zsh_highlight_styles[process-substitution-delimiter]='fg=#e8a831'
        # zsh_highlight_styles[single-hyphen-option]='fg=#aca1cf'
        # zsh_highlight_styles[double-hyphen-option]='fg=#aca1cf'
        # zsh_highlight_styles[back-quoted-argument]='fg=#282828,bg=#e8a831'
        # zsh_highlight_styles[single-quoted-argument]='fg=#e8a831'
        # zsh_highlight_styles[double-quoted-argument]='fg=#e8a831'
        # zsh_highlight_styles[dollar-quoted-argument]='fg=#e8a831'
        # zsh_highlight_styles[rc-quote]='fg=#aca1cf'
        # zsh_highlight_styles[dollar-double-quoted-argument]='fg=#cb6fa1'
        # zsh_highlight_styles[back-double-quoted-argument]='fg=#aca1cf'
        # zsh_highlight_styles[back-dollar-quoted-argument]='fg=#aca1cf'
        # zsh_highlight_styles[assign]='fg=#cb6fa1'
        # zsh_highlight_styles[redirection]='fg=#e8a831,bold'
        # zsh_highlight_styles[comment]='fg=#282828,bold'
        # zsh_highlight_styles[named-fd]='fg=#b9aeda'
        # zsh_highlight_styles[numeric-fd]='fg=#b9aeda'
        # zsh_highlight_styles[arg0]='fg=#c9c7cd'
        # zsh_highlight_styles[default]='fg=#c9c7cd'
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

    direnv = {
      enable = true;
      enableZshIntegration = true;
      config = { };
      silent = true;

      nix-direnv.enable = true;
    };
  };
}
