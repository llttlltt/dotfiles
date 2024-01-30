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

echo "🔧 STARTING HOMEBREW SETUP"

# Check if Homebrew is installed
if command -v brew >/dev/null 2>&1; then
  echo "🔧 Homebrew already exists, skipping install.\n"
else
  echo "🔧 Homebrew doesn't exist, continuing with install.\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "🔧 STARTING HOMEBREW BUNDLING PROCESS"
echo "🔧 Preparing to install packages and applications from the Brewfile located at: $brewfile_path"

echo "🔧 Executing 'brew bundle' to install the listed items from the Brewfile...\n"

# Store the original values of HOMEBREW_NO_AUTO_UPDATE and HOMEBREW_CASK_OPTS
original_homebrew_no_auto_update=$HOMEBREW_NO_AUTO_UPDATE
original_homebrew_cask_opts=$HOMEBREW_CASK_OPTS

# Set or update HOMEBREW_NO_AUTO_UPDATE and HOMEBREW_CASK_OPTS as needed
set_or_update_env_var HOMEBREW_NO_AUTO_UPDATE 1
set_or_update_env_var HOMEBREW_CASK_OPTS "$(echo "$HOMEBREW_CASK_OPTS" | sed -e 's/--no-quarantine//') --no-quarantine"

brew bundle --verbose --file="$brewfile_path"

# Reset HOMEBREW_NO_AUTO_UPDATE and HOMEBREW_CASK_OPTS to their original values or unset them
reset_env_var HOMEBREW_NO_AUTO_UPDATE $original_homebrew_no_auto_update
reset_env_var HOMEBREW_CASK_OPTS $original_homebrew_cask_opts

echo "\n🔧 Brewfile processing complete. All packages and applications have been installed or updated.\n"
