# dotfiles

Personal configuration managed with [chezmoi](https://www.chezmoi.io/). The primary target is an Apple Silicon personal Mac. A portable `base` profile also supports Omarchy/Arch Linux without taking ownership of Omarchy's desktop or system configuration.

## Profiles

Every machine receives the portable base configuration:

- Neovim
- Git
- Zsh
- tmux
- starship
- bat and shared CLI configuration

Machine-local chezmoi data selects a role (`personal`, `work`, or `server`) and the `development`, `audio`, `electronics`, and `gitSigning` capabilities. Darwin additionally receives Ghostty, Karabiner, Leader Key, flavours, PowerShell, Pi configuration, and other macOS-specific settings already represented here.

## Bootstrap

### Existing checkout

The installer initializes this checkout as the chezmoi source but does not modify live files by default:

```sh
./install
chezmoi --source "$PWD" diff
./install --apply
```

Applying is interactive so existing files are never silently replaced.

Install packages separately:

```sh
./scripts/install-packages
```

On the primary Mac, the default `personal` role preserves the complete pre-migration Brewfile. Override profile selection for other Macs with `DOTFILES_ROLE`, `DOTFILES_DEVELOPMENT`, `DOTFILES_AUDIO`, and `DOTFILES_ELECTRONICS` when running the package installer.

### New machine

Install chezmoi, initialize the repository, inspect the diff, and apply interactively:

```sh
chezmoi init Elliott-Liu/dotfiles
chezmoi diff
chezmoi apply --interactive
```

On Omarchy, chezmoi manages user configuration only. Package installation uses `pacman`; Omarchy's Hyprland and system configuration remain untouched.

## Daily workflow

Edit the source state, inspect, then apply:

```sh
chezmoi cd
$EDITOR source/dot_config/nvim/init.lua
chezmoi diff
chezmoi apply
```

Use `chezmoi re-add <target>` only for applications that rewrite a managed configuration file. Never ingest generated state automatically.

Useful checks:

```sh
./scripts/doctor
./scripts/validate
./scripts/package-audit
./scripts/package-snapshot
```

`package-audit` only reports drift; it does not uninstall anything. `package-snapshot` replaces the old `./bundle` workflow by generating a temporary Brewfile and showing the difference without overwriting the curated manifest.

Development runtimes are declared in `source/dot_config/mise/config.toml`; run `mise install` (also performed by the explicit package installer) to converge them.

## Secrets

Secrets do not belong in Git. The intended provider is the 1Password CLI (`op`). Non-secret configuration remains usable when `op` is missing or signed out. Chezmoi is configured to reject secrets detected during `chezmoi add`.

The previously committed Plex token must be rotated separately. Removing it from the current tree does not remove it from Git history. See [history sanitization](docs/history-sanitization.md) before undertaking the destructive rewrite.

## macOS preferences

Run `./scripts/macos-defaults` explicitly to apply the curated user-scoped preferences. Privileged changes, security settings, licenses, application logins, and permissions remain manual; see [manual setup](docs/manual-setup.md).

## Recovery and migration

Before the first cutover, follow [migration and recovery](docs/migration.md). In particular, tag the last Dotbot commit and back up affected live files. Dotbot is not used by the new configuration.

## Scope rule

Track authored intent, not incidental state. Do not commit credentials, caches, histories, recent-file lists, automatic backups, device paths, package-manager state, or generated application snapshots.
