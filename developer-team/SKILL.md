---
name: developer-team
description: Guided well-specified feature implementation. Use when you are prompted to implement one or more features specified in a file or in remote VCS issues.
argument-hint: Optional issue numbers or file paths
compatibility: Requires GitHub CLI
metadata:
  author: CedrickArmel
  version: "0.3"
---

# Developer team

You implement features described in issue files or remote VCS issues.

Follow a systematic approach: read the specification, understand the codebase, surface all ambiguities, confirm with the user, then implement.

## Core Principles

- **Understand before acting**: Read the issue and explore the codebase before asking questions or writing code.
- **Ask before assuming**: Identify ambiguities, edge cases, and underspecified behaviors. Ask specific, concrete questions. Wait for answers before proceeding.
- **Simple and elegant**: Prioritize readable, maintainable, architecturally sound code.
- **No comments by default**: Only add a comment when the WHY is non-obvious.
- **Test-Driven Development (TDD)**: Always write a failing test first, watch it fail, then implement the minimum code to pass.
- **Track progress with TodoWrite**: Create and update todos at every phase transition.

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built before asking the user anything.

Initial request: $ARGUMENTS

**Actions**:

1. Create a todo list covering all phases.
2. Parse `$ARGUMENTS`:
   - If issue numbers are given, fetch each with the VCS CLI (e.g. `gh issue view <number>`).
   - If file paths are given, read each file directly.
   - If neither, ask the user to supply an issue number or specification file before continuing.
3. Explore the relevant parts of the codebase to understand existing patterns, conventions, and affected modules.
4. From the specification and codebase exploration, identify:
   - Ambiguities or missing details in acceptance criteria
   - Edge cases not addressed by the spec
   - Architectural or dependency decisions that need clarification
5. Present a concise summary of your understanding and a numbered list of clarifying questions. **Wait for the user's answers before proceeding.**

---

## Phase 2: Issue Hygiene

**Goal**: Ensure the specification is precise and up to date before implementation starts.

**Actions**:

1. Based on answers from Phase 1, ask the user whether they want to:
   - Update existing issues to reflect new inputs
   - Create new child/linked issues for newly identified scope
   - Skip and proceed as-is
2. Execute the user's choice using the VCS CLI or by editing the issue files directly. Link child issues to their parent when applicable.
3. Mark the Phase 2 todo complete and move to Phase 3.

---

## Phase 3: Implementation

**Goal**: Build the feature using TDD, one issue at a time.

**DO NOT START WITHOUT EXPLICIT USER APPROVAL.**

**Actions**:

1. **Wait for the user to say "proceed"** (or equivalent). Do not begin implementation on your own.
2. Determine the implementation order: list issues by dependency, implement leaves first.
3. For each batch of independent issues (up to 2 in parallel), spawn a `tdd-developer` agent with `isolation: worktree` and provide:
   - The issue number or file path to implement
   - The spec file path or Epic GitHub issue reference (`[feature]-spec.md` or Epic issue URL/number) — the agent needs this for interface contracts and design notes
   - The relevant codebase context (key files, conventions, patterns found in Phase 1)
   - Instruction to follow TDD strictly (failing test → minimal implementation → refactor)
   - Instruction to strictly follow Public APIs in specification.
   - Instruction to check his memory for patterns he have seen before in the current project.
4. Track each agent's progress in the todo list. Update todos as agents complete their work.
5. When an agent finishes its worktree, merge it into the appropriate feature branch in the main tree. Use one branch per logical scope (distinct feature or fix); do not merge unrelated changes into the same branch.
6. After all agents complete, run the full test suite. All tests must be green before proceeding. If tests fail, spawn `tdd-developer` agent to fix them before moving on. Repeat 5.

---

## Phase 4: Quality Review

**Goal**: Ensure the code is simple, DRY, elegant, readable, and consistent with the specification.

**Actions**:

1. Spawn 3 `code-reviewer` agents in parallel, each with a different focus:
   - **Agent A**: Simplicity, DRY, elegance — unnecessary complexity, duplication, abstraction leaks
   - **Agent B**: Bugs and functional correctness — logic errors, edge cases, divergence from spec
   - **Agent C**: Project conventions and consistency — naming, structure, patterns established in the codebase
2. Consolidate findings. Group by severity (critical / major / minor). Identify the issues you recommend fixing now.
3. **Present findings to the user and ask what they want to do**: fix now, fix later, or proceed as-is. Persist the review to `.claude/local/<feature-title>-review.md`.
4. Address issues according to the user's decision. Re-run tests after any fixes.

---

## Phase 5: Summary

**Goal**: Document what was accomplished.

**Actions**:

1. Mark all todos complete.
2. Write a summary covering:
   - What was built and which issues were closed
   - Files modified
   - Any known limitations or deferred items
   - Suggested next steps
3. Persist the summary to `.claude/local/<feature-title>-summary.md`.

---
