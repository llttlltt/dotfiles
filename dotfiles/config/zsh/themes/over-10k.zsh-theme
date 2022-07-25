# zsh Over 10,000 Theme

## GENERAL

local ZSH_THEME_COLOR_BG="black"
local ZSH_THEME_COLOR_TEXT="white"
local ZSH_THEME_COLOR_USER="green"
local ZSH_THEME_COLOR_PATH="yellow"
local ZSH_THEME_COLOR_GIT="white"
local ZSH_THEME_COLOR_TIME="white"
local ZSH_THEME_COLOR_DEPTH="magenta"

## GIT

local ZSH_THEME_GIT_PROMPT_PREFIX="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[green]%}%{$reset_color%}%{$bg[$ZSH_THEME_COLOR_BG]%} "
local ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_AHEAD="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[cyan]%} %{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_BEHIND="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[magenta]%} %{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[red]%} %{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[yellow]%} %{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_STAGED="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[green]%} %{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_UNMERGED="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[green]%} %{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_CLEAN="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[green]%} %{$reset_color%}"
local ZSH_THEME_GIT_PROMPT_STASHED="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[white]%} %{$reset_color%}"

git_info () {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

git_status() {
  local result gitstatus
  gitstatus="$(command git status --porcelain -b 2>/dev/null)"

  # check status of local repository
  local gitbranch="$(head -n 1 <<< "$gitstatus")"
  if [[ "$gitbranch" =~ '^## .*ahead' ]]; then
    result+="$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if [[ "$gitbranch" =~ '^## .*behind' ]]; then
    result+="$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if [[ "$gitbranch" =~ '^## .*diverged' ]]; then
    result+="$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  # check status of files
  local gitfiles="$(tail -n +2 <<< "$gitstatus")"
  if [[ -n "$gitfiles" ]]; then
    if [[ "$gitfiles" =~ $'(^|\n)\\?\\? ' ]]; then
      result+="$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi
    if [[ "$gitfiles" =~ $'(^|\n).[MTD] ' ]]; then
      result+="$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi
    if [[ "$gitfiles" =~ $'(^|\n)UU ' ]]; then
      result+="$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
    if [[ "$gitfiles" =~ $'(^|\n)[AMRD]. ' ]]; then
      result+="$ZSH_THEME_GIT_PROMPT_STAGED"
    fi
  else
    result+="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  # check if there are stashed changes
  if command git rev-parse --verify refs/stash &> /dev/null; then
    result+="$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  echo $result | xargs
}

git_prompt() {
  # check git information
  local gitinfo=$(git_info)
  if [[ -z "$gitinfo" ]]; then
    return
  fi

  # quote % in git information
  local output="${gitinfo:gs/%/%%}"

  # check git status
  local gitstatus=$(git_status)
  if [[ -n "$gitstatus" ]]; then
    output+="$gitstatus"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${output}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

## PROMPT

local ZSH_THEME_SPACER="%{$bg[$ZSH_THEME_COLOR_BG]%} %{$reset_color%}"
local ZSH_THEME_LEFT="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg[$ZSH_THEME_COLOR_TEXT]%}%{$reset_color%}"
local ZSH_THEME_RIGHT="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg[$ZSH_THEME_COLOR_TEXT]%}%{$reset_color%}"
local ZSH_THEME_BLOCKLEFT="%{$fg[$ZSH_THEME_COLOR_BG]%}%{$reset_color%}"
local ZSH_THEME_BLOCKRIGHT="%{$fg[$ZSH_THEME_COLOR_BG]%}%{$reset_color%}"

local ZSH_THEME_USER="%{$bg[$ZSH_THEME_COLOR_BG]%}%{$fg_bold[$ZSH_THEME_COLOR_USER]%}%n%{$reset_color%}"
local ZSH_THEME_PATH="%{$fg_bold[$ZSH_THEME_COLOR_TEXT]%}$PWD%{$reset_color%}"
local ZSH_THEME_PATHSHORT="%{$fg_bold[$ZSH_THEME_COLOR_TEXT]%}$(echo $PWD | perl -pe "s/(\w)[^\/]+\//\1\//g")%{$reset_color%}"
local ZSH_THEME_POINTER="%(?.%{$fg[green]%}.%{$fg[red]%})❱ %{$reset_color%}"

local ZSH_THEME_EXITSTATUS="%{$bg[$ZSH_THEME_COLOR_BG]%}%(?.%{$fg_bold[green]%}✔.%{$fg_bold[red]%}✘)%{$reset_color%}"
local ZSH_THEME_TIME="%{$bg[$ZSH_THEME_COLOR_BG]%}%F{$ZSH_THEME_COLOR_TIME}%*%f"
local ZSH_THEME_DEPTH="%{$bg[$ZSH_THEME_COLOR_BG]%}%F{$ZSH_THEME_COLOR_DEPTH}%B%L%b%f"

dynamic_path_length() {
  if [[ -n $(git_prompt) ]]; then
    local DYNAMIC_PATH
    # vcs_info found nothing so we have more space. Let's print a longer part of $PWD...
    DYNAMIC_PATH+="%{$fg_bold[$ZSH_THEME_COLOR_PATH]%}$(echo $PWD | perl -pe "s/(\w)[^\/]+\//\1\//g")%{$reset_color%}"
    DYNAMIC_PATH+="${ZSH_THEME_SPACER}"
    DYNAMIC_PATH+="${ZSH_THEME_LEFT}"
    DYNAMIC_PATH+="${ZSH_THEME_SPACER}"
    DYNAMIC_PATH+="$(git_prompt)"
  else
    # vcs_info found something that needs space, a shorter $PWD makes sense.
    DYNAMIC_PATH+="%{$fg_bold[$ZSH_THEME_COLOR_PATH]%}%~%{$reset_color%}"
  fi
  echo "%{$bg[$ZSH_THEME_COLOR_BG]%}$DYNAMIC_PATH%{$reset_color%}"
}

build_header_prompt() {
  CUSTOM_HEADER="${ZSH_THEME_SPACER}"
  CUSTOM_HEADER+="${ZSH_THEME_USER}"
  CUSTOM_HEADER+="${ZSH_THEME_SPACER}"
  CUSTOM_HEADER+="${ZSH_THEME_LEFT}"
  CUSTOM_HEADER+="${ZSH_THEME_SPACER}"
  CUSTOM_HEADER+="$(dynamic_path_length)"
  CUSTOM_HEADER+="${ZSH_THEME_SPACER}"
  CUSTOM_HEADER+="${ZSH_THEME_BLOCKRIGHT}"
  echo "${CUSTOM_HEADER}"
}

build_rprompt() {
  CUSTOM_RPROMPT="${ZSH_THEME_BLOCKLEFT}"
  CUSTOM_RPROMPT+="${ZSH_THEME_SPACER}"
  CUSTOM_RPROMPT+="${ZSH_THEME_EXITSTATUS}"
  CUSTOM_RPROMPT+="${ZSH_THEME_SPACER}"
  CUSTOM_RPROMPT+="${ZSH_THEME_RIGHT}"
  CUSTOM_RPROMPT+="${ZSH_THEME_SPACER}"
  CUSTOM_RPROMPT+="${ZSH_THEME_TIME}"
  CUSTOM_RPROMPT+="${ZSH_THEME_SPACER}"
  CUSTOM_RPROMPT+="${ZSH_THEME_RIGHT}"
  CUSTOM_RPROMPT+="${ZSH_THEME_SPACER}"
  CUSTOM_RPROMPT+="${ZSH_THEME_DEPTH}"
  CUSTOM_RPROMPT+="${ZSH_THEME_SPACER}"
  echo "${CUSTOM_RPROMPT}"
}

over10k_precmd() {
  print
  print -rP $(build_header_prompt)
}

setopt prompt_subst
PROMPT="${ZSH_THEME_POINTER}"
RPROMPT="$(build_rprompt)"

autoload -U add-zsh-hook
add-zsh-hook precmd over10k_precmd