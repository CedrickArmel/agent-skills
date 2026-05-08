# Improving a Skill

## How to think about improvements

* **Generalize from feedback.** The skill will be used across many different prompts, not just the test cases. Avoid overfitting — if there's a stubborn issue, try different metaphors or patterns rather than adding rigid constraints.

* **Keep the prompt lean.** Read the transcripts, not just final outputs. If the model is wasting time on unproductive steps, remove the parts of the skill causing that.

* **Explain the why.** Don't write ALWAYS or NEVER in all caps when you can explain the reasoning instead. LLMs understand context and motivation — give them that rather than hard rules.

* **Look for repeated work across test cases.** If all 3 test cases resulted in the subagent writing a similar helper script, the skill should bundle it in `scripts/`. Write it once; save every future invocation from reinventing it.

Take your time. Write a draft improvement, then look at it with fresh eyes before applying it.

## The iteration loop

1. Apply improvements to the skill
2. Rerun all test cases into a new `iteration-<N+1>/` directory, including baseline runs
3. Launch the reviewer with `--previous-workspace` pointing at the previous iteration
4. Wait for the user to review
5. Read the new feedback, improve again, repeat

**Baseline choice for iteration 2+:**
* New skill: always `without_skill` (no skill) — stays the same across iterations
* Existing skill: use judgment — original version the user brought in, or previous iteration

Stop when:
- The user says they're happy
- All feedback is empty
- No meaningful progress