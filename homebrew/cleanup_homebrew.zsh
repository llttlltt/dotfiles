#!/usr/bin/env zsh

echo "📦 Starting Homebrew maintenance..."

# Check if Homebrew is installed
if command -v brew >/dev/null 2>&1; then
  echo "🔧 Cleaning up Homebrew...\n"
  brew cleanup && echo "\n✅ Homebrew cleanup complete.\n" || echo "\n⚠️ Warning: Homebrew cleanup encountered an issue.\n"
else
  echo "🔧 Homebrew not found. Initiating installation..."
  if [ -f ./homebrew/setup_homebrew.zsh ]; then
    ./homebrew/setup_homebrew.zsh
  else
    echo "⚠️ Error: Homebrew installation script not found."
  fi
fi
