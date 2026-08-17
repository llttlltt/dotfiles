# Configuration management workflow

The repository uses one of three ownership modes for every configuration file. Do not choose a workflow based on whether chezmoi happens to use a template internally; use the ownership mode below.

## 1. Repository-owned configuration

Shell, Git, Neovim, tmux, helper scripts, package manifests, and similar authored configuration are repository-owned. Edit their files directly under `~/.dotfiles/source`, then review and apply them:

```sh
./scripts/status
./scripts/apply
```

`scripts/apply` validates the repository, shows the chezmoi diff, and applies interactively. Do not edit the rendered home-directory copies and then use `re-add` when the source file is a template.

## 2. Application-owned configuration

Edit these through their application, then capture the approved subset:

```sh
./scripts/capture leader-key
./scripts/capture karabiner
./scripts/capture kicad
./scripts/capture flavours
```

Use `./scripts/capture all` after changing several applications. Each capture updates only an explicit allowlist:

| Capture group | Managed state |
| --- | --- |
| `leader-key` | Leader Key actions JSON |
| `karabiner` | Karabiner-Elements configuration JSON |
| `kicad` | KiCad 10 hotkeys, library tables, and the custom colour theme |
| `flavours` | Flavours configuration and its generated tmux theme |

Always inspect `./scripts/status` and `git diff` after capture. Commit only deliberate changes.

The authoritative current group list is available from:

```sh
./scripts/capture list
```

## 3. Local generated state

Caches, histories, recent-file lists, automatic backups, databases, credentials, tokens, device paths, and application runtime state remain local. Do not capture them.

## Keeping the policy current

Whenever a new configuration is added, decide its ownership explicitly:

1. Repository-owned: add it under `source` and edit it there.
2. Application-owned: add only the authored subset, add a named allowlist entry to `scripts/capture`, and update the table above.
3. Generated/local: ignore it and document an exception only if its purpose is unclear.

Never make an application-owned target a chezmoi template. Put machine-specific behavior in a small repository-owned templated helper, as Leader Key does for its Obsidian action. This keeps application capture safe and predictable.
