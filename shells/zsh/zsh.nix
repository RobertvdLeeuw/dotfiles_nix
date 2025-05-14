{ config, pkgs, ... }:

{
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      zplug
    ];
  };

	programs = {
    # steam.enable = true;
    zsh = {
      enable = true;
      shellAliases = {
        rebuild = "nixos-rebuild build --use-remote-sudo";
        update = "nixos-rebuild switch --use-remote-sudo";

        cnfnix = "cd /etc/nixos && sudo nvim configuration.nix && cd -";
        cnfhome = "cd /mnt/storage/nc/Personal/dotfiles/home-manager && nvim home.nix && cd -";
        cnfvim = "cd /mnt/storage/nc/Personal/dotfiles/home-manager && nvim nvim/nvim.nix && cd -";

        # dv = "find ./src/ && fd --type f --exclude __pycache__ | fzf -q src/ | xargs -r nvim";
        todo = "nvim ~/Documents/todo.md";
        books = "nvim ~/Documents/books.txt";
      };
      shellInit = builtins.readFile ../shells/zsh/init.sh;  # Split hotkeys into separate file?
      promptInit = builtins.readFile ../shells/zsh/prompt.sh;
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
	};
}
