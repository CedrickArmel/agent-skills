---
name: pr-open
description: >
  Opens a GitHub pull request for the current branch. Use when the user says "open a PR",
  "create a PR", "submit this branch", "push to PR", or asks to open PRs for one or more
  branches. Checks whether a PR already exists before creating one, and generates a
  meaningful title and description from the branch diff. Also use proactively when a branch
  has been synced and rebased and the next logical step is opening a PR.
allowed-tools:
  - Bash(git *)
  - Bash(gh *)
context: fork
compatibility: Requires git and gh (GitHub CLI) authenticated to the target repo.
metadata:
  author: drxc
  version: "0.1"
---

# pr-open

> Note: this skill runs in a forked context and does not see prior conversation history.
> If the user specified a base branch or title earlier, that context is unavailable — derive from git/gh data or ask if unclear.

Open a GitHub pull request for the current branch, or report the existing one.

## Context

- Current branch: !`git branch --show-current`
- Existing PRs for this branch: !`gh pr list --head $(git branch --show-current) --json number,title,state,url 2>/dev/null`
- Repo default branch: !`gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null || echo "main"`

## Step 1 — Pre-flight checks

Using the injected context:

- If **Current branch** is empty, the repo is in detached HEAD state — tell the user and exit.
- If an **open** PR already exists for this branch: report its number and URL, then stop.
- If a **closed or merged** PR exists: note it but continue — the user wants a new one.

## Step 2 — Understand the changes

Substitute the actual values from the injected context:
- `<base>` = injected Repo default branch (e.g. `main`)
- `<branch>` = injected Current branch

```bash
git fetch origin <base>
git log --oneline origin/<base>..<branch>
git diff origin/<base>...<branch> --stat
git diff origin/<base>...<branch>
```

If the branch has zero commits ahead of `<base>`, tell the user and exit — do not open a PR.

From the diff, derive:
- A concise PR **title** (≤ 70 chars, Conventional Commits style: `feat:`, `fix:`, `chore:`, `docs:`, etc.)
- A **summary** of what changed and why (2–4 bullet points)
- A **test plan** checklist appropriate to the type of change

## Step 3 — Push and create the PR

First ensure the branch exists on the remote:

```bash
git push -u origin <branch>
```

If the push fails (auth error, protected branch, no remote configured), report the error and stop — do not proceed to `gh pr create`.

Then create the PR using the derived `<title>` and body:

```bash
gh pr create --base <base> --head <branch> --title "<title>" --body "$(cat <<'EOF'
## Summary

- <bullet 1>
- <bullet 2>

## Test plan

- [ ] <test step>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

The body **must** end with `🤖 Generated with [Claude Code](https://claude.com/claude-code)`.

> Draft PRs are not handled by this skill — pass `--draft` manually if needed.

## Step 4 — Report

Print the PR URL returned by `gh pr create`.

## Gotchas

- If `origin` is not the correct remote (e.g. the user works with `upstream`/fork remotes), confirm the push target before pushing.
- If the user explicitly names a different base branch, use that instead of the repo default.
- Do not include credential-like strings (API keys, tokens) in the generated PR description.
