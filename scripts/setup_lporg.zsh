#!/usr/bin/env zsh

echo "📦 Starting LPORG (Launchpad) setup..."

# Define base directory
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the configuration file
CONFIG_FILE="$BASEDIR/dotfiles/Library/Application Support/lporg/config.yml"

# Check if lporg is installed and the configuration file exists
if command -v lporg >/dev/null 2>&1 && [ -f "$CONFIG_FILE" ]; then
	echo "🔧 lporg detected. Loading configuration from $CONFIG_FILE."
	lporg load --config "$CONFIG_FILE" --backup --yes
fi
