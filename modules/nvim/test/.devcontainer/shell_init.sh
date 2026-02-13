#!/bin/bash

# Switch to zsh for configuration
exec zsh -c '
    # Zsh completion setup
    autoload -U compinit
    zmodload zsh/complist
    compinit
    _comp_options+=(globdots)

    zstyle ":completion:*" matcher-list "m:{a-z}={a-zA-Z}"
    zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
    zstyle ":completion:*" menu no

    zstyle ":fzf-tab:complete:cd:*" fzf-preview "ls --color \$realpath"

    # Key bindings
    bindkey "^I" complete-word        # tab
    bindkey "^[[Z" forward-word       # shift + tab
    bindkey "^[^I" autosuggest-accept # shift + tab

    clear-terminal() {
        tput reset
        zle redisplay
    }
    zle -N clear-terminal
    bindkey "^[l" clear-terminal
    bindkey -M viins "^[l" clear-terminal

    # History search
    bindkey "^[k" history-search-backward
    bindkey "^[j" history-search-forward
    bindkey -M viins "^[k" history-search-backward
    bindkey -M viins "^[j" history-search-forward

    # Make configurations persistent
    cat >> ~/.zshrc << EOF
# Initialize tools (installed via features)
eval "\$(zoxide init --cmd cd zsh)"
eval "\$(fzf --zsh)"
eval "\$(starship init zsh)"

# Completion setup
autoload -U compinit
zmodload zsh/complist
compinit
_comp_options+=(globdots)

zstyle \":completion:*\" matcher-list \"m:{a-z}={a-zA-Z}\"
zstyle \":completion:*\" list-colors \"\${(s.:.)LS_COLORS}\"
zstyle \":completion:*\" menu no
zstyle \":fzf-tab:complete:cd:*\" fzf-preview \"ls --color \\\$realpath\"

# Key bindings
bindkey \"^I\" complete-word
bindkey \"^[[Z\" forward-word
bindkey \"^[^I\" autosuggest-accept

clear-terminal() { tput reset; zle redisplay; }
zle -N clear-terminal
bindkey \"^[l\" clear-terminal
bindkey -M viins \"^[l\" clear-terminal

bindkey \"^[k\" history-search-backward
bindkey \"^[j\" history-search-forward
bindkey -M viins \"^[k\" history-search-backward
bindkey -M viins \"^[j\" history-search-forward
EOF

    echo "Zsh configuration complete!"
'
