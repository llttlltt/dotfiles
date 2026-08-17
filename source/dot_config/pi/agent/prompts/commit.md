---
description: Commit changes (Conventional Commits), optionally with a custom date offset.
argument-hint: "[offset | absolute_timestamp]"
---

# Commit

Create a git commit where both the **Author** and **Committer** dates are shifted by the offset: `${1:-now}`. If the offset is `now` (the default), commit with the current system time.

**Environment**: This uses the BSD `date` utility (macOS). Construct the `-v` flags to match the requested offset.

**Steps:**

1.  **Calculate the date**: Parse the offset `${1:-now}` into the correct `date -v` flags.
    - _Now_: `date -Iseconds` (no offset flags).
    - _Hours/Minutes_: `date -v+6H -v+30M -Iseconds`
    - _Days_: `date -v-2d -Iseconds`
    - _Absolute_: If a specific timestamp is given, format it directly to `-Iseconds`.
2.  **Verify**: Echo the calculated date string and confirm it matches the intent before committing.
3.  **Honor `.gitignore`**: If a `.gitignore` exists, ensure no ignored files are staged before committing.
4.  **Commit**: Apply the date to both variables, using the **Conventional Commits** standard for the message (e.g., `feat:`, `fix:`, `chore:`, `refactor:`).

```bash
# Generated based on offset: ${1:-now}
export GDATE="$(date -Iseconds)"
GIT_AUTHOR_DATE="$GDATE" GIT_COMMITTER_DATE="$GDATE" git commit -m "<type>: <description>"
```
