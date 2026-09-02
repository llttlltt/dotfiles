#!/bin/sh
# @tuna.name Window - Toggle Pin Mode
# @tuna.subtitle Toggle Rectangle Pro Pin Mode
# @tuna.icon symbol:power
# @tuna.mode inline
# @tuna.input none
# @tuna.output none

exec "$HOME/.config/zsh/user/scripts/global_keyboard_shortcut_for_app.sh" \
  "Rectangle Pro" \
  p \
  command,control,option,shift
