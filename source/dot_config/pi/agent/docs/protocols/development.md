# Development Standards

## Code Style

- **Formatting**: Tabs, double quotes, and semicolons.
- **Patterns**: Prefer functional programming patterns.

## TypeScript & Type Safety

- **Flow**: Define types at the source; prioritize type inference.
- **Typecasting**: Avoid `as any` or `as Type` in production.
- **Debug Escape Hatches**: `any`/`unknown` are for temporary troubleshooting only and must be replaced before completion.

## Git Workflow

- **Pre-Commit**: Run `pnpm format`, `lint`, `check`, and `test` before committing.
- **PR Format**: `[<project_name>] <Title>`.
