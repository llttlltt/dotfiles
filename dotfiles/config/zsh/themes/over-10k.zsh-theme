# zsh Over 10,000 Theme

## GENERAL

local ZSH_THEME_COLOR_BG="black"
local ZSH_THEME_COLOR_TEXT="white"
local ZSH_THEME_COLOR_USER="green"
local ZSH_THEME_COLOR_PATH="yellow"
local ZSH_THEME_COLOR_GIT="blue"
local ZSH_THEME_COLOR_TIME="white"
local ZSH_THEME_COLOR_DEPTH="magenta"

local ZSH_THEME_LEFT="%{$fg[$ZSH_THEME_COLOR_TEXT]%}%{$reset_color%}"
local ZSH_THEME_RIGHT="%{$fg[$ZSH_THEME_COLOR_TEXT]%}%{$reset_color%}"
local ZSH_THEME_BLOCKLEFT="%{$fg[$ZSH_THEME_COLOR_BG]%}%{$reset_color%}"
local ZSH_THEME_BLOCKRIGHT="%{$fg[$ZSH_THEME_COLOR_BG]%}%{$reset_color%}"
local ZSH_THEME_BLOCKRIGHT="%{$fg[$ZSH_THEME_COLOR_BG]%}%{$reset_color%}"

local ZSH_THEME_PATH="%{$fg_bold[$ZSH_THEME_COLOR_TEXT]%}$PWD%{$reset_color%}"
local ZSH_THEME_PATHSHORT="%{$fg_bold[$ZSH_THEME_COLOR_TEXT]%}$(echo $PWD | perl -pe "s/(\w)[^\/]+\//\1\//g")%{$reset_color%}"
local ZSH_THEME_POINTER="%(?.%{$fg[green]%}.%{$fg[red]%})❱ %{$reset_color%}"

local ZSH_THEME_EXITSTATUS="%(?.%{$fg_bold[green]%}✔.%{$fg_bold[red]%}✘)%{$reset_color%}"
local ZSH_THEME_TIME="%F{$ZSH_THEME_COLOR_TIME}%*%f"
local ZSH_THEME_DEPTH="%F{$ZSH_THEME_COLOR_DEPTH}%B%L%b%f"

## GIT

local ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[green]%}±%{$reset_color%}%{$fg_bold[white]%}"
local ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
local ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

autoload -Uz add-zsh-hook vcs_info
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ":vcs_info:git:*" formats "${ZSH_THEME_LEFT} %F{cyan}%b%u%c%f"
zstyle ":vcs_info:git:*" actionformats "${ZSH_THEME_LEFT} %F{cyan}%b|%a%u%c%f"
zstyle ':vcs_info:*' unstagedstr ' $ZSH_THEME_GIT_PROMPT_UNSTAGED'
zstyle ':vcs_info:*' stagedstr ' $ZSH_THEME_GIT_PROMPT_STAGED'

## PROMPT

build_prompt_header() {
  CUSTOM_PROMPT="%F{green}%B%n%b%f ${ZSH_THEME_LEFT} "
  if [[ -n ${vcs_info_msg_0_} ]]; then
    # vcs_info found nothing so we have more space. Let's print a longer part of $PWD...
    CUSTOM_PROMPT+="%F{yellow}%B$(echo $PWD | perl -pe "s/(\w)[^\/]+\//\1\//g")%b%f $(git_prompt)"
    
  else
    # vcs_info found something that needs space, a shorter $PWD makes sense.
    CUSTOM_PROMPT+="%F{yellow}%B%~%b%f"
  fi
  CUSTOM_PROMPT+=" ${ZSH_THEME_BLOCKRIGHT}"
}

precmd() {
  vcs_info
  build_prompt_header
}

over10k_precmd() {
  print
  print -rP "$CUSTOM_PROMPT"
}

setopt prompt_subst
PROMPT="$ZSH_THEME_POINTER"
RPROMPT="${ZSH_THEME_BLOCKLEFT} ${ZSH_THEME_EXITSTATUS} ${ZSH_THEME_RIGHT} ${ZSH_THEME_TIME} ${ZSH_THEME_RIGHT} ${ZSH_THEME_DEPTH} "

autoload -U add-zsh-hook
add-zsh-hook precmd over10k_precmd