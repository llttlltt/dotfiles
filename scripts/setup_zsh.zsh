#!/usr/bin/env zsh

echo "\n<<< STARTING ZSH SETUP >>>"

# Installation unnecessary; it's in the brewfile.

echo "Enter superuser (sudo) password to edit /etc/shells"
echo '/opt/homebrew/bin/zsh' | sudo tee -a '/etc/shells'

echo "Enter user password to change login shell"
chsh -s "/opt/homebrew/bin/zsh"