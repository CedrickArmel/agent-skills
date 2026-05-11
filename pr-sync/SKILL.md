---
name: pr-sync
description: >
  Rebases the current branch onto its base branch, resolves any merge conflicts, and
  force-pushes to update the remote. Use when the user says "sync", "rebase", "fix
  conflicts", "the PR is not mergeable", "update my branch", or when a PR merge fails
  due to conflicts. Also use proactively after a base branch receives new commits that
  the feature branch needs.
compatibility: Requires git and gh (GitHub CLI) authenticated to the target repo.
allowed-tools: Bash(git *) Bash(gh *) Bash(jq *) Read Edit
metadata:
  author: CedrickArmel
  version: "1.1"
---

# PR-SYNC

Rebase the current branch onto its base, resolve conflicts, and force-push.

## Context

- Current branch: !`git branch --show-current`
- PR base branch: !`gh pr view --json baseRefName 2>/dev/null | jq -r '.baseRefName // empty' || gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null || echo "main"`
- Current status: !`git status --short`

## STEP 1 — Fetch and rebase

Use the injected **PR base branch** as the rebase target:

```bash
git fetch origin <base>
git rebase origin/<base>
```

If the rebase succeeds with no conflicts, jump to Step 3.

## STEP 2 — Resolve conflicts (if any)

For each conflicted file:

1. Read the file — conflict markers are `<<<<<<<`, `=======`, `>>>>>>>`.
2. Resolve intelligently — do not blindly pick one side:
   - Preserve additions from both sides when they are compatible.
   - When comments are in different languages, normalise to English.
   - When one side is a style/formatting fix and the other adds logic, apply both.
3. Stage the resolved file: `git add <file>`
4. Continue: `git rebase --continue`

Repeat until `git rebase --continue` exits cleanly.

## STEP 3 — Force-push

```bash
git push --force-with-lease origin <branch>
```

Use `--force-with-lease`, not `--force` — it refuses to push if the remote has commits the local branch doesn't know about, preventing accidental overwrites.

## STEP 4 — Report

Summarise:
- How many commits were rebased
- Which files had conflicts and how they were resolved
- Confirm the push succeeded

## Gotchas

- If `git push --force-with-lease` is rejected, the remote has diverged — run `git fetch origin <branch>` and investigate before pushing.
- Match the rebase target to the PR's base branch, not blindly to `main`.
- If `git rebase --continue` opens an editor for a commit message, the default message is fine — save and close.
