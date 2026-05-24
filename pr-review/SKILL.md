---
name: pr-review
description: >
  Reviews a GitHub pull request: fetches the diff, analyzes code quality and project conventions, then posts a structured review comment on the PR. Use when you are prompted to review or check a pull request (PR). Also proactivelly trigger when a PR is ready to be reviewed before merging. Posts the review as a GitHub comment and locally.
allowed-tools: Bash(gh pr *)
context: fork
arguments: number
compatibility: Requires gh (GitHub CLI) authenticated to the target repo.
metadata:
  author: drxc
  version: "0.1"
---

# pr-review

> Note: this skill runs in a forked context and does not see prior conversation history.
> The PR number must be passed as an argument or derived from the injected context below.

Analyze a PR diff and post a structured review comment on GitHub.

## Context

PR metadata:
!`gh pr view $number 2>/dev/null || echo "NO_PR_DATA"`

PR diff:
!`gh pr diff $number 2>/dev/null || echo "NO_DIFF_DATA"`

## Step 1 — Resolve the PR number

Check the injected PR metadata above:

- If it contains `NO_PR_DATA` or is empty, no valid PR number was resolved. Run `gh pr list` to show open PRs and ask the user which to review, then restart from Step 2 with the confirmed number.
- If valid metadata is present, proceed using the injected data.

## Step 2 — Analyze the diff

The PR metadata and diff are already injected above. Evaluate across these dimensions:

| Dimension        | What to check                                                                              |
| ---------------- | ------------------------------------------------------------------------------------------ |
| **Correctness**  | Logic errors, off-by-ones, wrong assumptions, hardcoded values that should be configurable |
| **Conventions**  | English-only comments, consistent naming style, project-specific patterns                  |
| **Security**     | Hardcoded credentials, unsafe deserialization, injection risks                             |
| **Code quality** | Placeholder values left in, dead code, misleading naming, unnecessary complexity           |
| **Consistency**  | Does the structure (module layout, entry points, config) match the rest of the repo?       |

Classify each finding as:

- **Critical** — likely bug or security issue, blocks merge
- **Minor** — style or naming, non-blocking
- **Note** — optional suggestion

Only report findings you are confident about. Omit any severity bucket with nothing to flag rather than writing "None."

## Step 3 — Post the review comment

Substitute `$number` with the resolved PR number. Omit any section (`Critical`, `Minor`, `Notes`) that has no findings.

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

## Step 4 — Report to the user

Print the same review summary inline so the user sees it without opening GitHub.

## Gotchas

- If the injected diff is empty, the PR may already be merged or the branch is up to date — check `gh pr view $number` for state before posting.
- Do not post the review comment more than once — check `gh pr view $number --json reviews` to verify no review was already posted this session.
- `allowed-tools` is scoped to `Bash(gh pr *)` — only `gh pr` subcommands are permitted.
