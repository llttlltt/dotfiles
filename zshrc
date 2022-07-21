# SET VARIABLES
## Bypass MacOS Gatekeeper for Homebrew Cask Installs
export HOMEBREW_CASK_OPTS="--no-quarantine"

# CHANGE ZSH OPTIONS

# CREATE ALIASES
## Coloured output for ls and git status using exa
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'
## Syntax highlighting for man (manual) pages using bat-extras
alias man=batman
## Syntax highlighting for grep (search) using bat-extras
alias grep=batgrep

# CUSTOMISE PROMPT(S)
PROMPT='
%B%F{green}%n%f%b @ %F{cyan}%m%f in %B%F{yellow}%~%f%b
> '

RPROMPT='%* | %B%F{red}%L%f%b'

# ADD LOCATIONS TO $PATH VARIABLE
## Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# WRITE FUNCTIONS
## Make a directory, and cd into it
function mkcd() {
  mkdir -p "$@" && cd "$_"
}

# USE ZSH PLUGINS

# ...AND OTHER SUPRISES