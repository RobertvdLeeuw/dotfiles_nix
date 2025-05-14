autoload -Uz vcs_info
precmd() { vcs_info }

precmd() {
  vcs_info
  # Print a newline before the prompt, but only if it's not the first prompt
  if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
    NEW_LINE_BEFORE_PROMPT=1
  elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
    echo ""
  fi
}

# Configure vcs_info for git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{green}'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}'
zstyle ':vcs_info:git:*' formats '──[%B%%F{cyan}%b%u%c%%F{cyan}%%f]'

# Function to detect virtual environments
function virtualenv_info {
  if [[ -n $VIRTUAL_ENV ]]; then
    echo "──[%F{yellow}%B$(basename $VIRTUAL_ENV)%b%f]"
  else
    echo ""
  fi
}

# Colors for username and current directory - easily customizable
USERNAME_COLOR="green"
DIRECTORY_COLOR="magenta"


function username_info {
  if [[ "$USER" != "robert" ]]; then
    echo "[%B%F{$USERNAME_COLOR}%n%f%b]──"
  else
    echo ""
  fi
}


# Set the prompt  TODO: GIT STATUS
setopt PROMPT_SUBST
PROMPT='┌──$(username_info)[%B%F{$DIRECTORY_COLOR}%~%f%b]$(virtualenv_info)
└─ '
export VIRTUAL_ENV_DISABLE_PROMPT=1
