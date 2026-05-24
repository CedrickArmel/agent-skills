---
name: commit-changes
description: >
  Use when you are prompted to commit changes or save a codebase work, or you plan to - even if the word "commit" is not used. using the "word commit". Groups all changes into logical units, places each on the right branch, and commits them with validated Conventional Commits messages.
allowed-tools: Bash(git *)
compatibility: Requires /commit-message
context: fork
metadata:
  author: CedrickArmel
  version: "0.2"
---

# Commit changes

> Note: this skill runs in a forked context and does not see prior conversation history.
> If the user described what to commit earlier in the conversation, that context is unavailable here — ask if anything is unclear.

## Context

- Initial intent: $ARGUMENTS
- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Existing branches: !`git branch -a`
- Recent commits: !`git log --oneline -10`

## Overview

Groups all pending changes into logical units, places each on the correct branch, then stages, validates, and commits them one by one using the `commit-message` skill for each message.

## Instructions

### Step 1 — Analyse changes

Inspect the injected context. Distinguish between:

- **No changes at all** → bail early, tell the user, and exit.
- **Changes exist but none are staged** → warn the user, ask whether to proceed with staging, and wait for confirmation before continuing.

Group the remaining changes by logical unit (e.g. one skill, one feature, one fix). Each independent unit becomes its own commit on its own branch.

### Step 2 — Determine the right branch for each group

For each group of changes:

1. Identify the conventional commit type (`feat`, `fix`, `refactor`, `chore`, etc.) and scope.
2. Derive the expected branch name following the `conventional branch` specification with a `<type>/<branch-description>` syntax (e.g. `feat/add-login-page`, `fix/header-bug`, `release/v1.2.0`).
3. Check if that branch already exists (see context above):
   - **Exists** → check out that branch and commit the group there.
   - **Does not exist** → detect the default base branch by running `git symbolic-ref refs/remotes/origin/HEAD --short 2>/dev/null | sed 's|origin/||'`; fall back to `main` if the command fails. Create the new branch from that base with `git checkout -b <branch> <base>`, then commit.
   - **Current branch already matches** → commit directly without switching.

### Step 3 — Stage and commit each group

For each group on its branch:

1. Stage only the files belonging to that group.
2. Invoke the `commit-message` skill to draft and validate the commit message.
3. Commit using the validated message.

Repeat for every group before finishing.

### Gotchas

- Untracked files belonging to a different group will follow you across branch switches — only stage what belongs to the current group.
- Never commit to the default branch directly; always use a feature/fix branch.
- If a group's files are already staged for the wrong branch, unstage them before switching.
- If a pre-commit hook fails, the commit did NOT happen — do not amend. Fix the issue, re-stage, and create a new commit.
- If the target branch has diverged from the base, warn the user before creating the commit.
