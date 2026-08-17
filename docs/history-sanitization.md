# Git history sanitization

Credential rotation is the security fix. Rewriting history only reduces future exposure of the old value.

Before rewriting:

1. Rotate the Plex token and verify the old token no longer works.
2. Inventory local clones, forks, tags, open pull requests, and collaborators.
3. Create a private mirror backup.
4. Coordinate a freeze on pushes.
5. Use `git filter-repo` with a replacement expression that is prepared locally and never committed.
6. Verify every branch and tag with a secret scanner.
7. Review the rewritten graph before force-pushing.
8. Obtain explicit confirmation before force-pushing any remote ref.
9. Reclone or carefully repair every existing checkout.

This repository does not contain an automated force-push command. History rewriting is intentionally a separate destructive operation.
