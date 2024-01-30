#!/usr/bin/env zsh

echo "📦 Starting Rust setup..."

# Check if Rust is installed
if command -v rustup >/dev/null 2>&1; then
  echo "✅ Rust already installed, skipping installation..."
  rustup --version
else
  echo "🔧 Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  echo "✅ Rust installation complete."
fi
echo ""
