---
name: pr-review
description: >
  Reviews a GitHub pull request: fetches the diff, analyzes code quality and project
  conventions, then posts a structured review comment on the PR. Use when the user says
  "review PR #N", "review this PR", "check the diff", "code review", or when a PR is
  ready to be reviewed before merging. Always posts the review as a GitHub comment — do
  not just print it locally.
compatibility: Requires gh (GitHub CLI) authenticated to the target repo.
allowed-tools: Bash(gh *)
arguments: number
metadata:
  author: CedrickArmel
  version: "1.1"
---

# PR-REVIEW

Analyze a PR diff and post a structured review comment on GitHub.

## Context

PR metadata:
!`gh pr view $number`

PR diff:
!`gh pr diff $number`

## STEP 1 — Analyze the diff

The PR metadata and diff are already injected above. Evaluate across these dimensions:

| Dimension | What to check |
|---|---|
| **Correctness** | Logic errors, off-by-ones, wrong assumptions, hardcoded values that should be configurable |
| **Conventions** | License headers on new source files, English-only comments, consistent naming style |
| **Security** | Hardcoded credentials, unsafe deserialization, injection risks |
| **Code quality** | Placeholder values left in, dead code, misleading naming, unnecessary complexity |
| **Consistency** | Does the structure (module layout, entry points, config) match the rest of the repo? |

Classify each finding as:
- **Critical** — likely bug or security issue, blocks merge
- **Minor** — style or naming, non-blocking
- **Note** — optional suggestion

Only report findings you are confident about. Omit any severity bucket with nothing to flag rather than writing "None."

If no PR number was supplied, run `gh pr list` to show open PRs and ask the user which to review.

## STEP 2 — Post the review comment

```bash
gh pr review $number --comment --body "$(cat <<'EOF'
## Code Review

### Overview
<1-2 sentence summary of what the PR does>

### Findings

**Critical**
- <issue> — <why it matters>

**Minor**
- <issue>

**Notes**
- <optional suggestion>

### Verdict
<Safe to merge / Needs fixes before merge>

---
🤖 Reviewed with Claude Code
EOF
)"
```

The comment **must** end with `---\n🤖 Reviewed with Claude Code`.

## STEP 3 — Report to the user

Print the same review summary inline so the user sees it without opening GitHub.

## Gotchas

- If the injected diff is empty, the PR may already be merged or the branch is up to date — check `gh pr view $number` for state.
- Do not post the review comment more than once — check `gh pr view $number --json comments` if unsure whether a review was already posted this session.
