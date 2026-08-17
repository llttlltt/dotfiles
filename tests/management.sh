#!/bin/sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
guide="$repo_dir/docs/config-management.md"

"$repo_dir/scripts/capture" list | awk '{ print $1 }' | while IFS= read -r app; do
    if ! grep -Fq "\`$app\`" "$guide"; then
        printf 'Capture group %s is missing from %s.\n' "$app" "$guide" >&2
        exit 1
    fi
done

if ! grep -Fq '(docs/config-management.md)' "$repo_dir/README.md"; then
    printf '%s\n' 'README.md must link to docs/config-management.md.' >&2
    exit 1
fi
