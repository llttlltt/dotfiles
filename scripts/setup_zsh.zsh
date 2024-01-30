#!/usr/bin/env zsh

ZSH_PATH=/opt/homebrew/bin/zsh

echo "📦 Starting ZSH setup..."

# Add ZSH to the list of shells
if grep -Fxq "${ZSH_PATH}" '/etc/shells'; then
  echo "✅ ${ZSH_PATH} already exists in /etc/shells, skipping addition."
else
  echo "🔧 Adding ${ZSH_PATH} to /etc/shells..."
  echo "🔑 Enter superuser (sudo) password to edit /etc/shells"
  echo "${ZSH_PATH}" | sudo tee -a '/etc/shells' >/dev/null && echo "✅ ${ZSH_PATH} added to /etc/shells."
fi

# Change the default shell to ZSH
if [ "$SHELL" = "${ZSH_PATH}" ]; then
  echo "✅ SHELL is already ${ZSH_PATH}, no change needed."
else
  echo "🔧 Setting ${ZSH_PATH} as default login shell..."
  echo "🔑 Enter user password to change login shell"
  chsh -s "${ZSH_PATH}" && echo "✅ Default shell set to ${ZSH_PATH}."
fi

# Symlink sh to zsh
if sh --version | grep -q zsh; then
  echo "✅ /private/var/select/sh already symlinked to zsh, no action required."
else
  echo "🔧 Symlinking sh to zsh..."
  echo "🔑 Enter superuser (sudo) password to symlink sh to zsh"
  sudo ln -sfv '/bin/zsh' '/private/var/select/sh' && echo "✅ sh symlinked to zsh."

  # Uncomment the following line to use Homebrew's ZSH instead of the default macOS version
  # sudo ln -sfv "${ZSH_PATH}" '/private/var/select/sh' && echo "✅ sh symlinked to Homebrew's zsh."
fi
echo ""
