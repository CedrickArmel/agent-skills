# Agent Skills — Project Instructions

## Commit type for skill assets

`SKILL.md`, `assets/`, and `references/` files are **runtime artifacts read by AI agents**, not passive documentation. Wording, structure, and frontmatter changes directly affect triggering accuracy and execution behavior.

Apply commit types accordingly:

| Change | Type |
| --- | --- |
| New skill, new asset, new reference file | `feat` |
| Wording/instruction change that corrects wrong agent behavior | `fix` |
| Restructuring steps, frontmatter, or layout without changing intent | `refactor` |
| Adding clarifications, examples, or notes that extend (not correct) behavior — if the agent reads the file | `feat` |
| Dependency declarations, compatibility fields, metadata-only edits | `chore` |
| Human-only documentation the agent never reads (e.g. a changelog, a human-only readme with no `@reference` pointer) | `docs` |
