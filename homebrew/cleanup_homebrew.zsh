#!/usr/bin/env zsh

echo "\n<<< CLEANING HOMEBREW >>>\n"

if exists brew; then
  echo "Cleaning up Homebrew.\n"
  brew cleanup
else
  echo "Homebrew doesn't exist, switching to install.\n"
  ./homebrew/setup_homebrew.zsh
fi