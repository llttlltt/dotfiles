#!/usr/bin/env zsh

echo "<<< STARTING HOMEBREW SETUP >>>"

if exists brew; then
  echo "Homebrew already exists, skipping install.\n"
else
  echo "Homebrew doesn't exist, continuing with install.\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "<<< BUNDLING HOMEBREW >>>\n"

# TODO: Keep an eye out for a different `--no-quarantine` solution.
# Currently, you can't do `brew bundle --no-quarantine` as an option.
# It's currently exported in zshrc:
# export HOMEBREW_CASK_OPTS="--no-quarantine"
# https://github.com/Homebrew/homebrew-bundle/issues/474

brew bundle --verbose --file=./homebrew/brewfile