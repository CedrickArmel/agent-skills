---
name: test-design
description: >
  Teach how to write tests that are anchored to what the system does (or public APIs), not to which files or class exist (or internal/private methods) - based on Uncle Bob's Test Contravariance principle. Use this skill when evaluating codebase tests, deciding how to structure the tests before writing them, or anytime you have a task or question about writing, structuring, or organizing tests in codebase — especially when you face tests that break on every refactor problem, or the codebase has any fragile test design that could break on code change (e.g refactor). Also trigger when knowledge about what makes a good test is needed.
metadata:
  author: CedrickArmel
  version: "0.1"
---

# TEST DESIGN

Teach how to write tests that are anchored to **behavior** (what the system does), not to **structure** (which files or classes exist). The goal is tests that survive refactors.

Before proceeding, read Uncle Bob Martin's "Test Contravariance" (2017) @references/principle.md to explain the "why" behind each suggestion.

## Step 1 — Understand the codebase and the intent

If test files already has exists:

- Discover existing tests.
- Read 2–3 representative test files to understand current structure.

If no tests exist, skip to Step 2 with no existing files to analyze.

## Step 2 — Understand test desin red flags and diagnose structural coupling (if tests exist)

Look for these red flags in the test files you read:

1. **File mirroring** — a `test_X.py` for every `X.py` in production. Symptom: renaming a production file would break test discovery even if behavior didn't change.
2. **Testing private helpers directly** — tests that import or call functions not exposed in the public API (e.g., `_build_optimizer`, `_parse_row`).
3. **Test name describes implementation, not behavior** — e.g., `test_DataLoader_init`, `test_Trainer_step`, instead of `test_training_reduces_loss_over_epochs`.
4. **One test class = one production class** — a `class TestDataLoader` that has a method for every method of `DataLoader`.

Report what you find. Be specific: quote the test name or import, explain which red flag it triggers, and say what the consequence is (fragile refactors, false safety, etc.).

## Step 3 — Teach the principle in their terms

Explain the core idea using their codebase as the example. Key points to cover:

- **What to anchor tests to**: observable outputs and side effects visible through the public API — return values, raised exceptions, written files, HTTP responses.
- **What to ignore in tests**: internal class names, private functions, how many files something is split across.
- **The opposing-movement rule**: as production code gets more generic, tests get more specific (cover more edge cases). They move in opposite directions — that's what makes them independent.

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

- "But how do I test private helpers?" → Explain: test them indirectly through the public function that uses them. If a helper is complex enough to need direct tests, it may be worth exposing it in its own public module.
- "What if my public API is huge?" → Suggest splitting by user-facing scenario, not by method count.
- "How many tests per behavior?" → As many concrete scenarios as there are distinct outcomes: happy path, edge cases, error cases — not one per code branch.

## Gotchas

- A test can be behavior-anchored AND use mocks — mocking external dependencies (DB, HTTP) is fine. The smell is when tests mock _internal_ implementation details.
- "Public API" means the entry point a _caller_ would use, not just `public` in a language sense. A private helper called only internally is still an implementation detail even if it's importable.
- Don't push the user to delete all their existing tests at once. Suggest adding new behavior-anchored tests alongside, then removing the structural ones gradually.
