#!/usr/bin/env zsh

ZSH_PATH=/opt/homebrew/bin/zsh

echo "\n<<< STARTING ZSH SETUP >>>"
echo ""

# Installation unnecessary; it's in the brewfile.

# Add ZSH to the list of shells
if grep -Fxq ${ZSH_PATH} '/etc/shells'; then
  echo "${ZSH_PATH} already exists in /etc/shells, skipping step..."
else
  echo "Adding ${ZSH_PATH} to /etc/shells\n"
  echo "Enter superuser (sudo) password to edit /etc/shells"
  echo $ZSH_PATH | sudo tee -a '/etc/shells' > /dev/null
fi
echo ""

# Change the default shell to ZSH
if [ "$SHELL" = $ZSH_PATH ]; then
  echo "SHELL is already $ZSH_PATH, skipping step..."
else
  echo "Setting ${ZSH_PATH} as default login shell"
  echo "Enter user password to change login shell"
  chsh -s $ZSH_PATH
fi
echo ""

# Symlink sh to zsh
if sh --version | grep -q zsh; then
  echo "/private/var/select/sh already symlinked to /bin/zsh, skipping step..."
else
  # Looked promising, might remove later.
  echo "Symlinking sh to zsh..."
  echo "Enter superuser (sudo) password to symlink sh to zsh"
  sudo ln -sfv '/bin/zsh' '/private/var/select/sh'
  
  # I'd prefer to use the Homebrew updated version instead of default MacOS version.
  # sudo ln -sfv ${ZSH_PATH} '/private/var/select/sh'
fi
echo ""