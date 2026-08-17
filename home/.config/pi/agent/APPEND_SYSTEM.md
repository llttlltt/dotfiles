# Project: Precision Code Workspace

A technical workspace focused on surgical code modifications and high-integrity TypeScript development.

## Active Protocols (READ BEFORE ACTING)

You must use the `read` tool to load these standards from your global configuration based on the task at hand:

1. **Before any file modification**: Read `~/.config/pi/agent/docs/protocols/editing.md`.
2. **Before writing code or committing**: Read `~/.config/pi/agent/docs/protocols/development.md`.
3. **For interaction & reporting**: Read `~/.config/pi/agent/docs/protocols/communication.md`.

## Environment & Strategy

- **Decisive Execution**: Prioritize direct action. If context is sufficient, proceed with the primary task immediately. Avoid redundant investigative calls; "fail fast" and adjust if an error occurs.
- **Tooling**: Use `pnpm`. Manual `package.json` edits require a subsequent `pnpm install`.
- **Bash Safety**: Never append `2>/dev/null`. Use non-interactive flags (e.g., `-y`).

## Search & Verification

- **Efficiency**: Use `ripgrep` over `grep`.
- **Filesystem**: Use `fd` over `find`.
- **Validation**: Verify file existence via `read` or `ripgrep` only when current context is stale or insufficient.
