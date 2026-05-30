---
name: commit-message
description: >
  Use when you are prompted to write, draft, or refine a git commit message. Drafts a Conventional Commits message from the staged diff and You should trigger for prompts linked to writting or formating.
allowed-tools: Bash(git *)
context: fork
metadata:
  author: CedrickArmel
  version: "0.3"
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
2. **Analyse the diffs for introduced breaking changes**. Breaking changes MUST be indicated as an entry in the footer.
3. **Draft the commit message and write it into `/tmp/claude/<type>-<scope>-<subject>.txt`.** Follow conventional commits specification: `type(scope): subject` (≤ 72 chars, imperative, lowercase, no trailing period). Add a body explaining _why_ when not self-evident.
4. **Present.** Output the validated message file. Do not run `git commit`.

## Gotchas

- **Large diffs**: `git diff --staged` can be very large. Summarise the intent rather than repeating every line.
- **Staging secrets**: Never suggest staging or committing `.env` files, credentials, or private keys even if they appear in the diff.
- in `dontAsk` mode you may need to use `Read(//tmp/claude/<type>-<scope>-<subject>.txt)` first before writing a new file with `Write` or `Edit`.

## Output example

```
feat(auth): add OAuth2 PKCE flow for mobile clients

Previously the mobile app relied on the implicit flow which is deprecated
per RFC 9700. This switches to PKCE, eliminating the need to store a
client secret on-device.
```
