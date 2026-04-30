---
name: skill-creator
description: >
Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy.
---

# Skill Creator

A skill for creating and iteratively improving agent skills.

Start by reading @assets/communication-guide.md to calibrate how you explain things to this user.

Figure out where the user is in the process and jump in at the right stage. If they say "just vibe with me", skip the formal eval loop.

## Step 1 — Capture Intent

If the conversation already shows a workflow, extract it (tools used, steps, corrections, input/output formats). Otherwise ask:

1. What should this skill enable Claude to do?
2. When should it trigger?
3. What's the expected output format?
4. Do we need test cases? (Skills with objectively verifiable outputs benefit most — suggest a default but let the user decide.)

Then interview the user about edge cases, dependencies, example files, and success criteria. Research in parallel via subagents if useful. Don't write test prompts until this is settled.

## Step 2 — Write the Skill

See @references/writing-skills-guidance.md for format, anatomy, writing patterns, and progressive disclosure.

Fill in:

- `name` — skill identifier
- `description` — when to trigger + what it does. This is the primary trigger — make it "pushy" so the skill doesn't undertrigger.
- Body — step-by-step instructions, examples, edge cases

## Step 3 — Create Test Cases

Write 2–3 realistic test prompts. Share with the user for sign-off, then save to `evals/evals.json`.

See @assets/eval-spec.md for the JSON schema. Don't add assertions yet — those come in Step 4.

## Step 4 — Run and Evaluate

See @references/running-evals.md for the full procedure. Do NOT stop partway through this step.

High-level:

1. Spawn all runs (with-skill AND baseline) in the same turn
2. While runs are in progress, draft assertions — explain them to the user
3. Capture timing data as each run completes
4. Grade, aggregate, and launch the eval viewer
5. Tell the user to review and come back

When the user is done, read @feedback.json and move to Step 5.

## Step 5 — Improve

See @references/improving-skill.md for how to think about improvements and run the iteration loop.

Apply improvements → rerun → review → repeat until:

- The user says they're happy
- All feedback is empty
- No meaningful progress is being made

## Step 6 — Optimize Description (optional)

After the skill is in good shape, offer to optimize the `description` field for better triggering accuracy.

See @references/description-optimization.md for the full procedure.

## Step 7 — Package

Ask the user where to put the new created skill, then run:

```bash
python -m scripts.package_skill <path/to/skill-folder>
```
