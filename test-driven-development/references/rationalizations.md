# TDD Rationalizations — Extended Reasoning

Reference this when a user pushes back on TDD. The table in `SKILL.md` gives the one-line rebuttal; this file has the full argument for each.

---

## "I'll write tests after to verify it works"

Tests written after code pass immediately. Passing immediately proves nothing:

- They might test the wrong thing.
- They might test implementation details, not behavior.
- They might miss edge cases you forgot while writing the code.
- You never saw them catch the bug they're supposed to prevent.

Test-first forces you to see the test fail, proving it actually tests something real.

---

## "I already manually tested all the edge cases"

Manual testing is ad-hoc:

- No record of what you tested.
- Can't re-run when code changes.
- Easy to forget cases under pressure.
- "It worked when I tried it" ≠ comprehensive coverage.

Automated tests are systematic — they run the same way every time.

---

## "Deleting X hours of work is wasteful"

Sunk cost fallacy. The time is already gone. Your choice now:

- Delete and rewrite with TDD (more hours, high confidence).
- Keep it and add tests after (30 minutes, low confidence, likely latent bugs).

The real waste is keeping code you can't trust. Working code without real tests is technical debt that compounds.

---

## "TDD is dogmatic — being pragmatic means adapting"

TDD *is* pragmatic:

- Finds bugs before commit (faster than debugging in staging or production).
- Prevents regressions (tests catch breaks immediately).
- Documents behavior (tests show how to use the code).
- Enables refactoring (change freely, tests catch breaks).

"Pragmatic" shortcuts = debugging later = slower overall.

---

## "Tests after achieve the same goals — it's the spirit not the ritual"

No. Tests-after answer "what does this do?" Tests-first answer "what should this do?"

Tests-after are biased by the implementation. You test what you built, not what was required. You verify edge cases you remembered, not edge cases you discover by writing the test first.

Tests-first force edge case discovery before implementing. Thirty minutes of tests added after ≠ TDD. You get coverage, but you lose proof that the tests actually catch the bug.

---

## "This is different because..."

It isn't. Every project feels special to the person writing it. The rationalizations above apply universally. If something genuinely makes TDD impossible (generated code, throwaway prototype, configuration file), confirm that with the user before proceeding without tests.
