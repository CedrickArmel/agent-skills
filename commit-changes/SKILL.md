---
name: commit-changes
description: >
Use when you create a git commit. Guides you to create standardized, descriptive commit in line with the project specification.
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
context: fork
---

# Commit changes

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Instructions

Based on the above changes, create a single git commit following the steps below:

1. Stage the changes you want to commit
2. Draft the commit message for the staged changes
3. Commit the changes

You have the capability to call multiple tools in a single response. Stage and create the commit using a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
