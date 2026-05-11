---
name: pr-open
description: >
  Opens a GitHub pull request for the current branch. Use when the user says "open a PR",
  "create a PR", "submit this branch", "push to PR", or asks to open PRs for one or more
  branches. Checks whether a PR already exists before creating one, and generates a
  meaningful title and description from the branch diff. Also use proactively when a branch
  has been synced and rebased and the next logical step is opening a PR.
compatibility: Requires git and gh (GitHub CLI) authenticated to the target repo.
allowed-tools: Bash(git *) Bash(gh *)
metadata:
  author: CedrickArmel
  version: "1.1"
---

# PR-OPEN

Open a GitHub pull request for the current branch, or report the existing one.

## Context

- Current branch: !`git branch --show-current`
- Existing PRs for this branch: !`gh pr list --head $(git branch --show-current) --json number,title,state,url 2>/dev/null`
- Repo default branch: !`gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null || echo "main"`

## STEP 1 — Check for an existing PR

Read the injected **Existing PRs** context above.

- If an **open** PR exists: report its number and URL, then stop.
- If a **closed or merged** PR exists: note it but continue — the user wants a new one.
- If none: proceed to Step 2.

## STEP 2 — Understand the changes

Use the injected **Current branch** and **Repo default branch** to run:

```bash
git log --oneline origin/<base>..<branch>
git diff origin/<base>...<branch> --stat
git diff origin/<base>...<branch>
```

From this, derive:
- A concise PR **title** (≤ 70 chars, Conventional Commits style: `feat:`, `fix:`, `chore:`, `docs:`, etc.)
- A **summary** of what changed and why (2–4 bullet points)
- A **test plan** checklist appropriate to the type of change

## STEP 3 — Create the PR

Use the injected **Repo default branch** as base unless the user specifies otherwise.

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

## STEP 4 — Report

Print the PR URL returned by `gh pr create`.

## Gotchas

- If the branch has never been pushed, `gh pr create` will fail — run `git push -u origin <branch>` first, then retry.
- Do not open a PR if the branch has zero commits ahead of the base.
- If the user explicitly names a different base branch, use that instead of the repo default.
