#!/bin/sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_dir"

patterns='\.dotfiles/(home|dotfiles)|/opt/homebrew/Cellar/pi-coding-agent/[0-9]|BEETSDIR|/Volumes/Apps/Beets'
if git grep --no-index -En "$patterns" -- source packages scripts docs README.md install .github; then
    printf '%s\n' 'Obsolete or machine-specific configuration detected.' >&2
    exit 1
fi
