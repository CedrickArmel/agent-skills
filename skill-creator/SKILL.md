---
name: skill-creator
description: >
  Use when the user wants to create, edit, improve, test, or benchmark a skill — even if
  the word "skill" is never mentioned. Trigger when the user says "make a skill", "turn
  this into a skill", "wrap this workflow", "add this as a skill", "update this skill",
  "run evals", "test this skill", "optimize the description", or "benchmark". Also trigger
  proactively when the conversation contains a workflow the user has refined and the natural
  next step is capturing it as a reusable skill.
---

# Skill Creator

## Overview

A skill for creating and iteratively improving agent skills.

Start by reading @references/communication-guide.md to calibrate how you explain things to this user.

Figure out where the user is in the process and jump in at the right stage. If the user signals they want a lightweight process (e.g. "skip the evals", "just write the skill", "quick version"), skip Steps 4–6 and go straight to Step 7.

## Instructions

### Step 0 - Learn to write a viable skill

1. Reads @references/writing-skills-guidance.md for format, anatomy, writing patterns, and progressive disclosure.

2. Read @references/complete-skill-md-example.md for an example of valid `SKILL.md`.

3. Read @assets/workspace-structure.md for the workspace layout. Create directories as you go — not all upfront.
4. Confirm the workspace placement with the user

### Step 1 — Capture intent

Now you know what a skill is, start by understanding the user's intent. Build an minimum viable understanding of what kind of skill you're building. The current conversation might already contain a workflow the user wants to capture (e.g., they say "turn this into a skill"). If so, extract it from the conversation history first: **tools used**, **steps**, **corrections**, **input/output formats**.

Then proactively ask questions about:

- What should this skill enable Claude to do?
- When should it trigger?
- Anything needed to fill the `SKILL.md` `frontmatter`

Exit when you can sketch a rough outline of the skill and fill in the `frontmatter`

### Step 2 - Interview and Research

Stress-tests your hypothesis from the previous step by asking only questions that would change the design.

1. You can proactively ask questions about:

- Do we need test cases? (Skills with objectively verifiable outputs benefit most — suggest a default but let the user decide.)
- Edge cases
- Expected Input/output formats
- Dependencies
- Example files
- Success criteria

The practical test: if a question's answer couldn't change what you write, don't ask it

2. Research in parallel via subagents (if available or inline) if useful (the skill wraps an external API or unfamiliar domain).

Don't write test prompts until this is settled.

### Step 3 — Write the Skill

Fill in `SKILL.md` template @assets/skill-md-format.md. You may want to drop unrelevant fields in the `frontmatter` or add some relevant from the specification.

### Step 4 — Create Test Cases

Write 2–3 realistic test prompts. Share with the user for sign-off, then save to `<skill-name>/evals/evals.json`.

See @assets/schema-evals-json.md for the JSON format. Don't add assertions yet — those come in Step 5.

### Step 5 — Run and Evaluate

See @references/running-evals.md for the full procedure. Do NOT stop partway through this step.

High-level:

1. Spawn all runs (with-skill AND baseline) in the same turn
2. While runs are in progress, draft assertions — explain them to the user
3. Capture timing data as each run completes
4. Grade, aggregate, and launch the eval viewer
5. Tell the user to review and come back

When the user is done, read @feedback.json and move to Step 6.

### Step 6 — Improve

See @references/improving-skill.md for how to think about improvements and run the iteration loop.

Apply improvements → rerun → review → repeat until:

- The user says they're happy
- All feedback is empty
- No meaningful progress is being made

### Step 7 — Optimize Description (optional)

After the skill is in good shape, offer to optimize the `description` field for better triggering accuracy.

See @references/description-optimization.md for the full procedure.

## Environment-Specific Notes

The process described above is designed for `Claude Code`. There may be some variations if you are running in a different environnement like `Claude.ai` or `Cowork`.

1. Read @references/claude-ai-notes.md for `Claude.ai`'s environment-specific notes, ONLY IF you are running in `Claude.ai`.
2. Read @references/cowork-notes.md for `Cowork`'s environment-specific notes, ONLY IF you are running in `Cowork`.
