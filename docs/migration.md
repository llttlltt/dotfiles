# Migration and recovery

The repository source has migrated from Dotbot symlinks to chezmoi-managed files. Do not let both tools manage the same target.

## Before cutover

1. Commit or stash unrelated work.
2. Tag the final known-good Dotbot revision, for example `git tag dotbot-final <commit>`.
3. Create a private backup outside the repository. `-L` is important because the
   current Dotbot targets are symlinks:

   ```sh
   backup_dir="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
   mkdir -p "$backup_dir"
   rsync -aL "$HOME/.config/" "$backup_dir/config/"
   rsync -aL "$HOME/Library/Application Support/Leader Key/" "$backup_dir/leader-key/"
   rsync -aL "$HOME/Library/Preferences/flavours/" "$backup_dir/flavours/"
   cp -L "$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.zshenv" \
       "$HOME/.gitconfig" "$HOME/.gitignore_global" "$backup_dir/"
   ```

4. Run `./install`, inspect `chezmoi diff`, and resolve every unexpected replacement.
5. Run `./install --apply` and approve targets interactively.
6. Overlay the backed-up `.config` directory to preserve unmanaged runtime data,
   then reapply chezmoi so authored configuration wins:

   ```sh
   rsync -a "$backup_dir/config/" "$HOME/.config/"
   chezmoi --source "$PWD" apply
   ```

7. Run `./scripts/doctor` and `./scripts/validate`.
8. Start a fresh shell and verify Git, Neovim, tmux, Pi, and 1Password signing.
9. Run a second `chezmoi diff`; it should contain no unintended changes.

The backup may contain credentials. Keep it private and delete it manually once recovery is no longer necessary.

## Rollback

If cutover fails, stop applying chezmoi, restore the affected files from the private backup, and return to the `dotbot-final` tag for reference. Do not run the old Dotbot installer against files currently managed by chezmoi.

## Existing-file adoption

Chezmoi's source state is authoritative. Compare an existing target with `chezmoi diff <target>`. If the live version contains a deliberate change, inspect it and run `chezmoi re-add <target>` explicitly. Never bulk-adopt the home directory.
