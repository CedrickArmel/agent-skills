---
name: commit-message
description: >
  Use when the user asks to write, draft, or refine a git commit message.
  Drafts a Conventional Commits message from the staged diff and validates it
  with the project's configured validator, refining until it passes.
  Trigger phrases: "write a commit message", "draft a commit", "commit message
  for staged changes", "help me commit", "what should my commit say".
allowed-tools: Bash(git *)
context: fork
metadata:
  author: drxc
  version: "0.2"
---

# commit-message

Draft a Conventional Commits compliant message for the currently staged changes, validate it, refine until valid.

## Staged changes (auto-injected)

Stat:
!`git diff --staged --stat`

Diff:
!`git diff --staged`

## Steps

1. **Stop early if nothing staged.** If the injected diff is empty, tell the user and exit.
2. **Draft the commit message.** Follow conventional commits specification: `type(scope): subject` (≤ 72 chars, imperative, lowercase, no trailing period). Add a body explaining _why_ when not self-evident.
3. **Validate the message.** Check CLAUDE.md (project and global) for a validation command. Run the command found against the draft. If no validation command is configured, warn the user and skip validation.
4. **Refine on failure.** Read the validator's output, fix the violated rule, re-validate. Cap at 3 attempts; if still failing, surface the last error to the user and ask.
5. **Present.** Output the validated message in a fenced code block. Do not run `git commit`.

## Gotchas

- **Large diffs**: `git diff --staged` can be very large. Summarise the intent rather than repeating every line.
- **Validator CLI differences**: `commitlint`, `cz check`, and `conventional-commits-validator` all have different invocation patterns — read CLAUDE.md before assuming which one to use.
- **Staging secrets**: Never suggest staging or committing `.env` files, credentials, or private keys even if they appear in the diff.

## Output example

```
feat(auth): add OAuth2 PKCE flow for mobile clients

Previously the mobile app relied on the implicit flow which is deprecated
per RFC 9700. This switches to PKCE, eliminating the need to store a
client secret on-device.
```
