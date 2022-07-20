# SET VARIABLES
export HOMEBREW_CASK_OPTS="--no-quarantine"

# CHANGE ZSH OPTIONS

# CREATE ALIASES
# alias ls='ls -lAFh'
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'

# CUSTOMISE PROMPT(S)
PROMPT='
%1~ %L %# 
> '

RPROMPT='%*'

# ADD LOCATIONS TO $PATH VARIABLE
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# WRITE FUNCTIONS
function mkcd() {
  mkdir -p "$@" && cd "$_"
}

# USE ZSH PLUGINS

# ...AND OTHER SUPRISES