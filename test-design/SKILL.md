---
name: test-design
description: >
  Use this skill when the user asks how to write, structure, or organize tests — especially
  when they're new to testing, their tests break on every refactor, or they have one test
  file per production file. Also trigger when the user mentions "test design", "test structure",
  "how to test X", "my tests are fragile", or wants to understand what makes a good test.
  Teaches Uncle Bob's test contravariance principle: tests should be anchored to observable
  behavior, not to internal class/file structure. Does not edit files — teaches and shows
  by example using the user's own codebase.
compatibility: Any Python project using pytest. Read access to test files required.
allowed-tools: Read Bash
metadata:
  author: CedrickArmel
  version: "0.1"
---

# TEST DESIGN

Teach the user how to write tests that are anchored to **behavior** (what the system does),
not to **structure** (which files or classes exist). The goal is tests that survive refactors.

Read @references/principle.md before proceeding so you can explain the "why" behind each
suggestion.

## Step 1 — Understand what the user has (or wants)

If the user already has test files:
- Run `find . -name "test_*.py" -o -name "*_test.py" | head -30` to discover existing tests.
- Read 2–3 representative test files to understand current structure.

If the user is starting from scratch, skip to Step 2 with no existing files to analyze.

## Step 2 — Diagnose structural coupling (if tests exist)

Look for these red flags in the test files you read:

1. **File mirroring** — a `test_X.py` for every `X.py` in production. Symptom: renaming a
   production file would break test discovery even if behavior didn't change.
2. **Testing private helpers directly** — tests that import or call functions not exposed in
   the public API (e.g., `_build_optimizer`, `_parse_row`).
3. **Test name describes implementation, not behavior** — e.g., `test_DataLoader_init`,
   `test_Trainer_step`, instead of `test_training_reduces_loss_over_epochs`.
4. **One test class = one production class** — a `class TestDataLoader` that has a method
   for every method of `DataLoader`.

Report what you find. Be specific: quote the test name or import, explain which red flag it
triggers, and say what the consequence is (fragile refactors, false safety, etc.).

## Step 3 — Teach the principle in their terms

Explain the core idea using their codebase as the example. Key points to cover:

- **What to anchor tests to**: observable outputs and side effects visible through the
  public API — return values, raised exceptions, written files, HTTP responses.
- **What to ignore in tests**: internal class names, private functions, how many files
  something is split across.
- **The opposing-movement rule**: as production code gets more generic, tests get more
  specific (cover more edge cases). They move in opposite directions — that's what makes
  them independent.

Keep it concrete. If they have a `DataLoader`, show what a behavior-anchored test for it
would look like vs. what they currently have.

## Step 4 — Suggest a better structure

Propose new test file names and a brief description of what each should cover.
Use this format:

```
tests/
  test_<behavior>.py   ← covers: <what this tests in one sentence>
  test_<behavior>.py   ← covers: ...
```

Rules for naming:
- Name after the capability, not the class: `test_data_ingestion`, not `test_DataLoader`.
- One file per user-facing behavior, not per internal module.
- It's OK to have fewer test files than production files — that's a sign of good decoupling.

Then for each suggested file, write one example test function showing the right approach:
a stable entry point, a concrete scenario, an assertion on observable output.

## Step 5 — Answer follow-up questions

The user may ask:
- "But how do I test private helpers?" → Explain: test them indirectly through the public
  function that uses them. If a helper is complex enough to need direct tests, it may be
  worth exposing it in its own public module.
- "What if my public API is huge?" → Suggest splitting by user-facing scenario, not by
  method count.
- "How many tests per behavior?" → As many concrete scenarios as there are distinct
  outcomes: happy path, edge cases, error cases — not one per code branch.

## Gotchas

- A test can be behavior-anchored AND use mocks — mocking external dependencies (DB, HTTP)
  is fine. The smell is when tests mock *internal* implementation details.
- "Public API" means the entry point a *caller* would use, not just `public` in a language
  sense. A private helper called only internally is still an implementation detail even if
  it's importable.
- Don't push the user to delete all their existing tests at once. Suggest adding new
  behavior-anchored tests alongside, then removing the structural ones gradually.
