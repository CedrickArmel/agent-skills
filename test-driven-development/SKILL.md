---
name: test-driven-development
description: >
  Describe how to implement Test-Driven Devlopment (TDD) in your in your development workflow. Use when implementing any feature, fixing any bug, or refactoring any code — Especially you are prompted to write test first, red-green-refactor, write failing test, or you are about to change behavior in code even if the prompt doesn't explicitly say "test" or "TDD". Also trigger proactively when you are prompted to jump straight to writing implementation without mentioning tests.
metadata:
  version: "0.1"
---

# Test-Driven Development (TDD)

## Overview

Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

## Core Rule

**No production code without a failing test first.**

Write code before the test? Delete it and start over — keeping it as "reference" or "adapting" it while writing tests is still test-after. **Delete means delete**.

The rule exists because tests written after code are biased by the implementation you just built: you test what you made, not what was required. You discover edge cases after the fact instead of before. Tests-first force edge case discovery before implementing.

## TDD Red-Green-Refactor workflow

```
RED → verify fails correctly → GREEN → verify all pass → REFACTOR → verify still green → RED (next behavior)
```

Two feedback loops matter:

- **Wrong failure loop**: if the test errors (import, typo) rather than failing, fix the error and re-run until it fails for the right reason.
- **Stay-green loop**: after each refactor step, re-run the full suite before continuing.

### RED — Write one failing test

Write one minimal test showing what should happen. Use real code, not mocks, unless an external dependency makes it unavoidable.

<Good>

**Good:**

```typescript
test("retries failed operations 3 times", async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error("fail");
    return "success";
  };
  const result = await retryOperation(operation);
  expect(result).toBe("success");
  expect(attempts).toBe(3);
});
```

Clear name, tests real behavior, one thing.

</Good>

<Bad>

**Bad:**

```typescript
test("retry works", async () => {
  const mock = jest
    .fn()
    .mockRejectedValueOnce(new Error())
    .mockRejectedValueOnce(new Error())
    .mockResolvedValueOnce("success");
  await retryOperation(mock);
  expect(mock).toHaveBeenCalledTimes(3);
});
```

Vague name, tests mock behavior not code behavior.

</Bad>

_(Examples use TypeScript/Jest. Substitute your stack's test runner — `pytest`, `go test`, `cargo test`, etc.)_

**Requirements:** one behavior, clear name, real code.

### Verify RED — Watch it fail (don't skip)

```bash
npm test path/to/test.test.ts   # or your stack's equivalent
```

Confirm:

- Test **fails** (not errors — see wrong-failure loop above)
- Failure message describes the missing feature
- Fails because the feature is absent, not because of a typo

**Test passes immediately?** You're testing existing behavior. Fix or rethink the test.

### GREEN — Minimal code to pass

Write the simplest code that makes the test pass. Don't add features, refactor other code, or "improve" beyond the test.

<Good>

**Good:**

```typescript
async function retryOperation<T>(fn: () => Promise<T>): Promise<T> {
  for (let i = 0; i < 3; i++) {
    try {
      return await fn();
    } catch (e) {
      if (i === 2) throw e;
    }
  }
  throw new Error("unreachable");
}
```

</Good>

<Bad>

**Bad:** Adding configurable `maxRetries`, backoff options, callbacks — YAGNI. Those get their own failing tests when actually needed.

</Bad>

### Verify GREEN — Confirm full suite passes

```bash
npm test
```

- New test passes
- All other tests still pass
- Output clean (no errors, warnings)

**Other tests break?** Fix now — don't move on.

### REFACTOR — Clean up

After green only: remove duplication, improve names, extract helpers. Keep tests green throughout. Don't add behavior.

### Repeat

Next failing test for the next behavior.

## Bug Fix Example

**Bug:** Empty email accepted

**RED:**

```typescript
test("rejects empty email", async () => {
  const result = await submitForm({ email: "" });
  expect(result.error).toBe("Email required");
});
```

**Verify RED:**

```
FAIL: expected 'Email required', got undefined  ✓ right failure
```

**GREEN:**

```typescript
function submitForm(data: FormData) {
  if (!data.email?.trim()) return { error: "Email required" };
  // ...
}
```

**Verify GREEN:** All pass.

**REFACTOR:** Extract validation if needed.

## Common Rationalizations

| Rationalization                           | Reality                                                                               |
| ----------------------------------------- | ------------------------------------------------------------------------------------- |
| "Too simple to test"                      | Simple code breaks too. The test takes 30 seconds.                                    |
| "I'll test after"                         | Tests passing immediately prove nothing — you never saw them catch the bug.           |
| "Tests after achieve the same goals"      | Tests-after answer "what does this do?". Tests-first answer "what should this do?"    |
| "Already manually tested"                 | Ad-hoc ≠ systematic. No record, can't re-run, easy to forget under pressure.          |
| "Deleting X hours is wasteful"            | Sunk cost. Keeping unverified code is technical debt.                                 |
| "Keep as reference / adapt existing code" | That's test-after. Delete means delete.                                               |
| "Need to explore first"                   | Fine. Throw away the exploration. Start fresh with TDD.                               |
| "Test is hard to write"                   | The test is telling you the design is hard to use. Listen to it.                      |
| "TDD is dogmatic / I'm being pragmatic"   | TDD is pragmatic: finds bugs before commit, prevents regressions, documents behavior. |
| "Existing code has no tests"              | Add tests for each behavior you touch. You're improving it.                           |

For the reasoning behind each, read @references/rationalizations.md.

## Verification Checklist

Before marking work complete:

- [ ] Every new function/method has a test written before the implementation
- [ ] Watched each test fail before implementing
- [ ] Each test failed for the right reason (feature missing, not a typo/import error)
- [ ] Wrote minimal code to pass — no extras
- [ ] All tests pass
- [ ] Output clean (no errors, warnings)
- [ ] Tests use real code (mocks only when an external dependency forces it)
- [ ] Edge cases and error paths covered

Can't check all boxes? You skipped TDD. Delete the code and start over.

## When Stuck

| Problem                   | Solution                                                           |
| ------------------------- | ------------------------------------------------------------------ |
| Don't know how to test it | Write the wished-for API. Write the assertion first. Ask the user. |
| Test too complicated      | The design is too complicated. Simplify the interface.             |
| Must mock everything      | Code too coupled. Introduce dependency injection.                  |
| Test setup is huge        | Extract helpers. Still complex? Simplify the design.               |

## Testing Anti-Patterns

When adding mocks or test utilities, read @references/testing-anti-patterns.md to avoid common pitfalls — especially testing mock behavior instead of real behavior, and adding test-only methods to production classes.

## Gotchas

- **Wrong-failure vs no-failure**: a test that _errors_ on import or syntax is not a failing test — fix the error first, then confirm it fails for the right reason before writing implementation.
- **Snapshot tests are not TDD**: creating a snapshot on a function that doesn't exist yet will just snapshot an error. You never watched a meaningful failure. They don't count as a failing test.
- **Coverage ≠ TDD**: 100% coverage only tells you tests ran every line. It cannot tell you whether tests were written first or whether they would catch a regression. Don't use coverage as a proxy for TDD compliance.
