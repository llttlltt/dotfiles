#!/usr/bin/env zsh

echo "📦 Starting LPORG (Launchpad) setup..."

# Define base directory
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the configuration file
CONFIG_FILE="$BASEDIR/preferences/lporg_launchpad.yaml"
BACKUP_FILE="$BASEDIR/preferences/lporg_launchpad_backup.yaml"

# Check if lporg is installed and the configuration file exists
if command -v lporg >/dev/null 2>&1 && [ -f "$CONFIG_FILE" ]; then
  echo "🔧 lporg detected. Loading configuration from $CONFIG_FILE."
  # TODO load --backup has been replaced, fix this!
  if lporg load --backup "$CONFIG_FILE"; then
    mv "$HOME/.launchpad.yaml" "$BACKUP_FILE" && echo "✅ Launchpad configuration loaded and backed up to $BACKUP_FILE."
  else
    echo "⚠️ Warning: Could not load configuration from $CONFIG_FILE."
  fi
elif [ ! -f "$CONFIG_FILE" ]; then
  echo "⚠️ Configuration file not found at $CONFIG_FILE."
else
  echo "⚠️ lporg not found, skipping Launchpad setup."
fi
