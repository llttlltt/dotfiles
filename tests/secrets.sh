#!/bin/sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_dir"

patterns='PLEX_TOKEN|BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|gh[pousr]_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}'
if git grep --no-index -En "$patterns" -- source packages scripts docs README.md install .github; then
    printf '%s\n' 'Potential secret detected.' >&2
    exit 1
fi
