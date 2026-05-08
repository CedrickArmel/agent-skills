---
name: commit-changes
description: >
Use when you create a git commit. Guides you to create standardized, descriptive commit in line with the project specification.
allowed-tools: Bash(git *), Bash(git status), Bash(git add *), Bash(git commit *), Bash(git checkout *), Bash(git branch *)
context: fork
---

# Commit changes

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Existing branches: !`git branch -a`
- Recent commits: !`git log --oneline -10`

## Instructions

### Step 1 — Analyse changes

Group the changes by logical unit (e.g. one skill, one feature, one fix). Each independent unit should become its own commit on its own branch.

### Step 2 — Determine the right branch for each group

For each group of changes:

1. Identify the conventional commit type (`feat`, `fix`, `refactor`, `chore`, etc.) and scope.
2. Derive the expected branch name following the convention `<type>/<scope>` (e.g. `feat/commit-changes`, `fix/auth-token`, `refactor/skill-creator`).
3. Check if that branch already exists (see context above):
   - **Exists** → check out that branch and commit the group there.
   - **Does not exist** → create it from `main` with `git checkout -b <branch> main`, then commit.
   - **Current branch already matches** → commit directly without switching.

### Step 3 — Stage and commit each group

For each group on its branch:

1. Stage only the files belonging to that group.
2. Draft a commit message following the Conventional Commits spec.
3. Commit.

Repeat for every group before finishing.

### Gotchas

- Untracked files belonging to a different group will follow you across branch switches — only stage what belongs to the current group.
- Never commit to `main` directly; always use a feature/fix branch.
- If a group's files are already staged for the wrong branch, unstage them before switching.
