#!/usr/bin/env zsh

brewfile_path="$(pwd)/homebrew/brewfile"

# Function to set or update an environment variable
set_or_update_env_var() {
  local var_name=$1
  local new_value=$2
  [ -n "$new_value" ] && export "$var_name=$new_value"
}

# Function to reset an environment variable to its original value
reset_env_var() {
  local var_name=$1
  local original_value=$2
  [ -n "$original_value" ] && export "$var_name=$original_value" || unset "$var_name"
}

echo "📦 Starting Homebrew setup..."

# Check if Homebrew is installed
if command -v brew >/dev/null 2>&1; then
  echo "✅ Homebrew already exists, skipping installation.\n"
else
  echo "🔧 Homebrew not found, initiating installation...\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && echo "\n✅ Homebrew installation complete." || echo "\n\⚠️ Error: Homebrew installation failed."
fi

echo "📦 Starting Homebrew bundling process..."
echo "🔧 Preparing to install from the Brewfile located at: $brewfile_path"
echo "🔧 Executing 'brew bundle' for package installation...\n"

# Store the original values of HOMEBREW_NO_AUTO_UPDATE and HOMEBREW_CASK_OPTS
original_homebrew_no_auto_update=$HOMEBREW_NO_AUTO_UPDATE
original_homebrew_cask_opts=$HOMEBREW_CASK_OPTS

# Set or update HOMEBREW_NO_AUTO_UPDATE and HOMEBREW_CASK_OPTS as needed
set_or_update_env_var HOMEBREW_NO_AUTO_UPDATE 1
set_or_update_env_var HOMEBREW_CASK_OPTS "$(echo "$HOMEBREW_CASK_OPTS" | sed -e 's/--no-quarantine//') --no-quarantine"

brew bundle --verbose --file="$brewfile_path" && echo "\n✅ Homebrew setup and bundling complete.\n" || echo "\n\⚠️ Error occurred during Brewfile processing.\n"

# Reset HOMEBREW_NO_AUTO_UPDATE and HOMEBREW_CASK_OPTS to their original values or unset them
reset_env_var HOMEBREW_NO_AUTO_UPDATE $original_homebrew_no_auto_update
reset_env_var HOMEBREW_CASK_OPTS $original_homebrew_cask_opts
