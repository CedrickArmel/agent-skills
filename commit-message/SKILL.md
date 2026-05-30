---
name: commit-message
description: >
  Use when you are prompted to write, draft, or refine a git commit message. Drafts a Conventional Commits message from the staged diff and You should trigger for prompts linked to writting or formating.
argument-hint: "Optional: known breaking changes, issue/PR refs, or feature intent not visible in the diff"
allowed-tools: Bash(git *)
context: fork
metadata:
  author: CedrickArmel
  version: "0.4"
---

# commit-message

Draft a Conventional Commits compliant message for the currently staged changes, validate it, refine until valid.

## Caller context (optional)

$ARGUMENTS

If non-empty, this was passed by the caller (e.g. `commit-changes` skill, `developer-team` skill, or the user describing intent). Use it to supplement your analysis:

- **Known breaking changes**: semantic breaks not visible in the diff (removed public APIs, changed behaviour, dropped support) **MUST** appear as `BREAKING CHANGE:` footer entries even when the diff alone doesn't reveal them.
- **Issue / PR references**: include as `Closes #N` or `Refs #N` in the footer.
- **Feature intent**: use to clarify ambiguous diffs or write a more accurate commit body.

If `$ARGUMENTS` is empty, analyse the diff alone.

## Staged changes (auto-injected)

Stat:
!`git diff --staged --stat`

Diff:
!`git diff --staged`

## Steps

1. **Stop early if nothing staged.** If the injected diff is empty, tell the user and exit.
2. **Analyse for breaking changes.** Check both the staged diff and any caller context above. Semantic breaking changes flagged in caller context MUST be included in a `BREAKING CHANGE:` footer even if the diff alone doesn't reveal them.
3. **Draft the commit message and write it into `/tmp/claude/<type>-<scope>-<subject>.txt`.** Follow conventional commits specification: `type(scope): subject` (≤ 72 chars, imperative, lowercase, no trailing period). Add a body explaining _why_ when not self-evident.
4. **Present.** Output the validated message file path. Do not run `git commit`.

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

Closes #42
```
