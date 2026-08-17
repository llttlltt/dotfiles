---
description: Sync project context (CONTEXT.md, AGENTS.md, and plans)
---
# Sync Project Context

Perform a synchronization and pruning of the project documentation to ensure our context remains concise, accurate, and up-to-date.

## Workflow:
1. **Discovery**: Locate `./CONTEXT.md`, `./AGENTS.md`, and any active implementation plans in the `./plan/` directory or related subdirectories.
2. **Analysis**: Compare these files against our recent session history and the current state of the codebase. Identify:
   - Newly completed features or architectural shifts to add.
   - Obsolete information (outdated implementation details, resolved bugs, finished plans) to remove.
   - New "learnings" or conventions that should be codified in `AGENTS.md`.
3. **Execution (Apply the following principles)**:
   - **Pruning > Adding**: Actively remove information that is no longer relevant.
   - **Reference, Don't Duplicate**: Link to specific files instead of embedding large code snippets or implementation details.
   - **Resolve Inconsistencies**: Ensure `AGENTS.md` and `CONTEXT.md` are in sync with the current truth of the code.
   - **Surgical Updates**: Use `edit` for precise changes to existing files.

## Deliverables:
- Updated `CONTEXT.md`.
- Updated `AGENTS.md`.
- Updated or archived implementation plans.
- A brief summary of what was synchronized and pruned.
