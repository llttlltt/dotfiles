# AGENTS.md

## Code Style

- Use tabs instead of spaces
- Use double quotes
- Always include semicolons
- Prefer functional programming patterns where possible

## TypeScript

- Prefer using `pnpm`. When adding a package to a project, use an install command instead of manually editing `package.json`.
- Run `check`, `format`, and `lint` commands after completing a change. If these commands do not exist, suggest implementing them for the project.
- Avoid explicit return types unless absolutely necessary.
- Lean on type inference rather than manually defining new types repeatedly.
- Use `as any` only as an absolute last resort; always prioritize real type safety.
- Avoid running `dev` or `build` commands. If a build/dev command is required, ask for permission first.
- When asking questions, present them one at a time to ensure clarity and focus.
- Always read the full contents of a file every time; do not read subsets, as this ensures no important context is missed.

## PR Instructions

- `[<project_name>] <Title>`
- Always run `pnpm lint` and `pnpm test` before committing.

