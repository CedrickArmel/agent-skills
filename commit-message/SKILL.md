---
name: commit-message
description: Use when the user asks to write, draft, or refine a git commit message. Drafts a Conventional Commits message from the staged diff and validates it with the project's configured validator, refining until it passes.
user-invocable: true
context: fork
metadata:
  author: drxc
  version: "0.1"
---

# commit-message

Draft a Conventional Commits message for the currently staged changes, validate it, refine until valid.

## Staged changes (auto-injected)

Stat:
!`git diff --staged --stat`

Diff:
!`git diff --staged`

## Steps

1. **Stop early if nothing staged.** If the injected diff is empty, tell the user and exit.
2. **Draft.** Write `type(scope): subject` (≤ 72 chars, imperative, lowercase, no trailing period). Add a body explaining _why_ when not self-evident. Use `!` after type/scope or a `BREAKING CHANGE:` footer for breaking changes. Use the user's request as additional intent signal.
3. **Validate the message.** If a validation command is available from project context, run it against the draft. If no validation command is clear, warn the user and ask before proceeding.
4. **Refine on failure.** Read the validator's output, fix the violated rule, re-validate. Cap at 3 attempts; if still failing, surface the last error to the user and ask.
5. **Present.** Output the validated message in a fenced code block. Do not run `git commit`.
