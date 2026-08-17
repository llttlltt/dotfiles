#!/bin/sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
test_root=$(mktemp -d)
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

config_file="$test_root/chezmoi.toml"
mkdir -p "$test_root/home"
chezmoi --source "$repo_dir" --config "$config_file" --destination "$test_root/home" init \
    --promptChoice 'Machine role=personal' \
    --promptBool 'Install development tooling=true,Install audio tooling=true,Install electronics tooling=true,Use 1Password for Git signing=true' \
    --promptString 'Leader Key Obsidian vault=Elliott Liu,Leader Key Obsidian QuickAdd choice ID=bea8aca1-73dd-4abb-8cc3-41a7a0a984ed'

chezmoi --source "$repo_dir" --config "$config_file" --destination "$test_root/home" execute-template < "$repo_dir/source/dot_zshrc.tmpl" | zsh -n
chezmoi --source "$repo_dir" --config "$config_file" --destination "$test_root/home" execute-template < "$repo_dir/source/dot_zprofile.tmpl" | zsh -n
chezmoi --source "$repo_dir" --config "$config_file" --destination "$test_root/home" execute-template < "$repo_dir/source/dot_gitconfig.tmpl" >"$test_root/gitconfig"
git config --file "$test_root/gitconfig" --list >/dev/null
chezmoi --source "$repo_dir" --config "$config_file" --destination "$test_root/home" managed >/dev/null
chezmoi --source "$repo_dir" --config "$config_file" --destination "$test_root/home" apply

if [ -n "$(chezmoi --source "$repo_dir" --config "$config_file" --destination "$test_root/home" status)" ]; then
    printf '%s\n' 'A second chezmoi apply would change the rendered target.' >&2
    exit 1
fi
