---
name: pr-sync
description: >
  Rebases the current branch onto its base branch, resolves any merge conflicts, and force-pushes to update the remote. Use when the user says "sync", "rebase", "fix conflicts", "the PR is not mergeable", "update my branch", or when a PR merge fails due to conflicts. Also use proactively after a base branch receives new commits that the feature branch needs.
allowed-tools: Bash(git *) Bash(gh *) Read Edit
context: fork
compatibility: Requires git and gh (GitHub CLI) authenticated to the target repo.
metadata:
  author: CedrickArmel
  version: "0.2"
---

# pr-sync

> Note: this skill runs in a forked context and does not see prior conversation history.

Rebase the current branch onto its base, resolve conflicts, and force-push.

## Context

- Current branch: !`git branch --show-current`
- PR base branch: !`gh pr view --json baseRefName 2>/dev/null | jq -r '.baseRefName // empty' || gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null || echo "main"`
- Current status: !`git status --short`

## Step 1 — Pre-flight checks

Before rebasing, validate the injected context:

- If **Current branch** is empty, the repo is in detached HEAD state — tell the user and exit.
- If **Current branch** matches the **PR base branch**, the user is on the base branch itself — warn and exit.
- If **Current status** shows uncommitted changes (any non-empty output), tell the user and exit — `git rebase` will refuse to run with a dirty working tree.

Then fetch and rebase:

```bash
git fetch origin <base>
git rebase origin/<base>
```

Where `<base>` is the injected PR base branch and `<branch>` is the injected Current branch.

If the rebase reports "Already up to date" or "Current branch is up to date", skip to Step 4 and report that no rebase was needed.

If the rebase succeeds with no conflicts, skip to Step 3.

## Step 2 — Resolve conflicts (if any)

For each conflicted file:

1. Read the file — conflict markers are `<<<<<<<`, `=======`, `>>>>>>>`.
2. Resolve intelligently — do not blindly pick one side:
   - Preserve additions from both sides when they are compatible.
   - When comments are in different languages, normalise to English.
   - When one side is a style/formatting fix and the other adds logic, apply both.
3. Stage the resolved file: `git add <file>`
4. Continue: `git rebase --continue`

If `git rebase --continue` itself surfaces new conflicts (subsequent commits being replayed), return to step 1 of this section and repeat.

If a conflict cannot be resolved (e.g. binary file, structural incompatibility), run `git rebase --abort` to restore the branch to its pre-rebase state, then report the unresolvable conflict to the user and exit.

## Step 3 — Review and push

Before pushing, show the user a summary of all conflict resolutions made and ask for confirmation. AI-driven conflict resolution can introduce subtle logic errors — the user should verify before the force-push is irreversible.

Once confirmed:

```bash
git push --force-with-lease origin <branch>
```

Use `--force-with-lease`, not `--force` — it refuses to push if the remote has commits the local branch doesn't know about, preventing accidental overwrites.

If the push fails, report the error and do not retry automatically.

## Step 4 — Report

Summarise:

- Whether a rebase was needed or the branch was already up to date
- How many commits were rebased
- Which files had conflicts and how they were resolved
- Confirm the push succeeded (or report failure)

## Gotchas

- If `git push --force-with-lease` is rejected, the remote has diverged — run `git fetch origin <branch>` and investigate before pushing.
- Match the rebase target to the PR's base branch, not blindly to `main`.
- If `git rebase --continue` opens an editor for a commit message, the default message is fine — save and close.
