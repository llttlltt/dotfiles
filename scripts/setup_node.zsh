#!/usr/bin/env zsh

echo "\n<<< STARTING NODE SETUP >>>"
echo ""

# Node versions are managed with `nvm`, which is in the brewfile.
# See zshrc for NVM_DIR (this moves the install location out of Homebrew).

if exists node; then
  echo "Node $(node --version) & NPM $(npm --version) already exist, skipping install... "
else
  echo "Installing Node & NPM with nvm..."
  echo "Installing LTS.."
  nvm install --lts
  echo ""
  echo "Installing Latest..."
  nvm install node --default
  echo ""
fi
echo ""
