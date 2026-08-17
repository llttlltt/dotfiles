# Precision Editing Protocol

## Execution Rules

1. **Fresh Read**: Ensure the last `read` reflects the current file state before an `edit`.
2. **Literal Paths**: Use exact filepaths from results.
3. **Surgical Scope**: Target a single unique line for `oldText` to maximize success rates.
4. **Verbatim Content**: No placeholders; use character-for-character strings.

## Recovery

- **Stop on Failure**: If an edit fails, re-read the file immediately.
- **Simplify**: Revert to single-line replacements if multi-line attempts fail.
