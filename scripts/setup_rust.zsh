#!/usr/bin/env zsh

echo "\n<<< STARTING RUST SETUP >>>\n"

# Setup Rust

if exists rustup; then
  echo "Rust already exist, skipping install... "
  rustup --version
else
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
echo ""
