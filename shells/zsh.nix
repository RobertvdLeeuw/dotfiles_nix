{ config, pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        rebuild = "nixos-rebuild build --use-remote-sudo";
        update = "nixos-rebuild switch --use-remote-sudo";
        cnfnix = "cd /etc/nixos && sudo nvim configuration.nix && cd -";
        cnfhome = "cd /mnt/storage/nc/Personal/dotfiles/home-manager && nvim home.nix && cd -";
        cnfvim = "cd /mnt/storage/nc/Personal/dotfiles/home-manager && nvim nvim/nvim.nix && cd -";
        todo = "nvim ~/Documents/todo.md";
        books = "nvim ~/Documents/books.txt";
      };
      shellGlobalAliases = {
        nano = "nvim";
      };
      
      initContent = ''
        # Initialize zplug first
        source ${pkgs.zplug}/share/zplug/init.zsh
        
        # Give zplug time to run its initial setup if needed
        if [[ ! -d ~/.zplug/cache ]]; then
          mkdir -p ~/.zplug/cache
          # Force a zplug cache update
          zplug load --verbose
        fi
        
        # Initialize zoxide and fzf
        eval "$(zoxide init --cmd cd zsh)"
        eval "$(fzf --zsh)"
        
        # Include your custom init content
        ${builtins.readFile ./init.sh}
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
      
      # Better approach: use home-manager's plugin system instead of zplug
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
          };
        }
        # Add more plugins as needed
      ];
      
      autosuggestion = {
        enable = true;
        # highlight = "fg=8";  # You can uncomment and adjust this if needed
      };
    };
    
    # Add fzf configuration directly through home-manager
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    
    # Add zoxide configuration directly through home-manager
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
