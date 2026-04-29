# Skill writing guidance

## Progressive disclosure

Agents load skills *progressively*, pulling in more detail only as a task calls for it. Skills should be structured to take advantage of this:

1. **Metadata** (\~100 tokens): The `name` and `description` fields in the `frontmatter` are always loaded at startup for all skills.
2. **Instructions** (\< 5000 tokens recommended): The full `SKILL.md` `body` is loaded when the skill is activated
3. **Resources** (as needed): Files (e.g. those in `scripts/`, `references/`, or `assets/`) are loaded only when required

Keep your main `SKILL.md` `body` lean and under 500 lines. If approaching 500 lines:
- Move detailed reference material to separate files.
- Add clear pointers to where the model should go next.

When a skill supports multiple variants, organize by variant so Claude reads only what's relevant:

```
cloud-deploy/
├── SKILL.md
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```

## Writing patterns

1. **Use the imperative form** in instructions.

2. **Define output formats explicitly.** You can do it like this:

```markdown
## Report structure

ALWAYS use this exact template:
# [Title]

## Executive summary

## Key findings

## Recommendations
```
3. **Include examples**. It's useful to include examples. You can format them like this (but if "Input" and "Output" are in the examples you might want to deviate a little):

```markdown
## Commit message format

**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

## Writing style

1. Explain the why behind instructions — LLMs respond better to reasoning than rigid rules
2. Avoid ALWAYS/NEVER in all caps when you can explain the reason instead
3. Use theory of mind — make instructions general, not over-fit to specific examples
4. Draft first, then review with fresh eyes
Keep the prompt lean: remove anything that isn't pulling its weight