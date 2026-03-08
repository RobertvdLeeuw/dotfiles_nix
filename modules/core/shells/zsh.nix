{ config, pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;
      initContent = /* sh */ ''
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(fzf --zsh)"

        autoload -U compinit
        zmodload zsh/complist
        compinit -u
        _comp_options+=(globdots) # Include hidden files.

        zstyle ':completion:*' matcher-list 'm:{a-z}={a-zA-Z}'
        zstyle ':completion:*' list-colors '{(s.:.)LS_COLORS}'
        zstyle ':completion:*' menu no

        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

        bindkey '^I' complete-word        # tab
        bindkey '^[[Z' forward-word       # shift + tab
        bindkey '^[^I' autosuggest-accept # shift + tab

        clear-terminal() {
          tput reset
          zle redisplay
        }
        zle -N clear-terminal
        bindkey '^[l' clear-terminal
        bindkey -M viins '^[l' clear-terminal

        bindkey '^[k' history-search-backward
        bindkey '^[j' history-search-forward
        bindkey -M viins '^[k' history-search-backward
        bindkey -M viins '^[j' history-search-forward

        # eval "$(direnv hook zsh)"

        # Devcontainer exec helper
        forth() {
          local dir="$PWD"
          local devcontainer_dir=""

          # Search upward for .devcontainer/
          while [[ "$dir" != "/" ]]; do
            if [[ -d "$dir/.devcontainer" ]]; then
              devcontainer_dir="$dir"
              break
            fi
            dir="$(dirname "$dir")"
          done

          # Check if found
          if [[ -z "$devcontainer_dir" ]]; then
            echo "No devcontainer found!"
            return 1
          fi

          # If not in current directory, cd there first
          if [[ "$devcontainer_dir" != "$PWD" ]]; then
            cd "$devcontainer_dir"
            devcontainer exec /bin/zsh
            cd -
          else
            devcontainer exec /bin/zsh
          fi
        }

        set -o allexport
        source /etc/nixos/.env
        set +o allexport

        any-nix-shell zsh --info-right | source /dev/stdin
        export NIXPKGS_ALLOW_UNFREE=1
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

    # direnv = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   config = { };
    #   silent = true;
    #
    #   nix-direnv.enable = true;
    # };
  };
}
