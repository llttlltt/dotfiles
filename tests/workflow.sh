#!/bin/sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
test_root=$(mktemp -d)
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

test_repo="$test_root/repo"
test_home="$test_root/home"
mkdir -p "$test_repo/scripts" "$test_repo/source" "$test_home"
cp "$repo_dir/scripts/capture" "$repo_dir/scripts/status" "$test_repo/scripts/"
# shellcheck disable=SC2016
printf '%s\n' '#!/bin/sh' 'printf validated >"$HOME/validated"' >"$test_repo/scripts/validate"
chmod +x "$test_repo/scripts/validate"
printf '%s\n' source >"$test_repo/.chezmoiroot"

seed_file() {
    source_path=$1
    target_path=$2
    mkdir -p "$(dirname -- "$test_repo/source/$source_path")" "$(dirname -- "$test_home/$target_path")"
    printf '%s\n' original >"$test_repo/source/$source_path"
    printf '%s\n' original >"$test_home/$target_path"
}

seed_file 'private_Library/private_Application Support/Leader Key/config.json' 'Library/Application Support/Leader Key/config.json'
seed_file 'dot_config/karabiner/karabiner.json' '.config/karabiner/karabiner.json'
seed_file 'private_Library/private_Preferences/kicad/10.0/user.hotkeys' 'Library/Preferences/kicad/10.0/user.hotkeys'
seed_file 'private_Library/private_Preferences/kicad/10.0/fp-lib-table' 'Library/Preferences/kicad/10.0/fp-lib-table'
seed_file 'private_Library/private_Preferences/kicad/10.0/sym-lib-table' 'Library/Preferences/kicad/10.0/sym-lib-table'
seed_file 'private_Library/private_Preferences/kicad/10.0/design-block-lib-table' 'Library/Preferences/kicad/10.0/design-block-lib-table'
seed_file 'private_Library/private_Preferences/kicad/10.0/colors/user.json' 'Library/Preferences/kicad/10.0/colors/user.json'
seed_file 'private_Library/private_Preferences/flavours/config.toml' 'Library/Preferences/flavours/config.toml'
seed_file 'dot_config/tmux/tmux-ostentus.conf' '.config/tmux/tmux-ostentus.conf'

git -C "$test_repo" init --quiet
git -C "$test_repo" -c user.name=Test -c user.email=test@example.com add .
git -C "$test_repo" -c user.name=Test -c user.email=test@example.com commit --quiet -m initial

HOME="$test_home" "$test_repo/scripts/capture" check >/dev/null

printf '%s\n' changed >"$test_home/Library/Application Support/Leader Key/config.json"
HOME="$test_home" "$test_repo/scripts/capture" leader-key >/dev/null
cmp "$test_repo/source/private_Library/private_Application Support/Leader Key/config.json" \
    "$test_home/Library/Application Support/Leader Key/config.json"
[ -f "$test_home/validated" ]

for file in user.hotkeys fp-lib-table sym-lib-table design-block-lib-table colors/user.json; do
    printf 'changed %s\n' "$file" >"$test_home/Library/Preferences/kicad/10.0/$file"
done
printf '%s\n' local-only >"$test_home/Library/Preferences/kicad/10.0/recent.json"
HOME="$test_home" "$test_repo/scripts/capture" kicad >/dev/null
for file in user.hotkeys fp-lib-table sym-lib-table design-block-lib-table colors/user.json; do
    cmp "$test_repo/source/private_Library/private_Preferences/kicad/10.0/$file" \
        "$test_home/Library/Preferences/kicad/10.0/$file"
done
[ ! -e "$test_repo/source/private_Library/private_Preferences/kicad/10.0/recent.json" ]

leader_source="$test_repo/source/private_Library/private_Application Support/Leader Key/config.json"
mv "$leader_source" "$leader_source.tmpl"
if HOME="$test_home" "$test_repo/scripts/capture" leader-key >/dev/null 2>&1; then
    printf '%s\n' 'capture accepted an application-owned template' >&2
    exit 1
fi
mv "$leader_source.tmpl" "$leader_source"

printf '%s\n' repository-change >>"$leader_source"
HOME="$test_home" DOTFILES_OS=Darwin "$test_repo/scripts/status" | \
    grep -Eq 'leader-key[[:space:]]+source/.+Leader Key/config.json'
