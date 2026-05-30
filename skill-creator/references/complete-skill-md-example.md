## Complete `SKILL.md` example

<Card>

```yaml SKILL.md
---
name: pr-summary
description: Use to summarize changes in a pull request.
license: MIT
allowed-tools: Bash(gh pr diff *) Bash(gh pr view *)
disable-model-invocation: false
user-invocable: true
context: fork
agent: Explore
metadata:
  author: CedrickArmel
  version: "1.0"
---

# PR SUMMARY

## Step 1 - Pull request context analysis

Analyse the following PR:

- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Step 2 - Pull Request Summary

Summarise the pull request...
```
</Card>

When this skill runs:
1. A subagent context fork is created as `context: fork` is set, with `Explore` as agent.
2. Each `` !`<command>` `` executes immediately (before the agent sees anything). The output replaces the placeholder in the skill content: that's `dynamic context injection`
3. The agent receives the fully-rendered prompt with actual PR data.

Note: Any command other than `gh` commands would have failed as `allowed-tools: Bash(gh *)` is set and only allow `gh` commands.

Note: The skill will be available both for the agent and the user as `disable-model-invocation: false` and `user-invocable: true` are set respectively.
