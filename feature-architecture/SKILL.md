---
name: feature-architecture
description: Guided feature designing with codebase understanding. Use when you are designing the specs for a new feature, a bug fix, a codebase refactor, or any dev-related architecture work — even if it's not explicitly mentioned.
argument-hint: Optional feature description
metadata:
  author: CedrickArmel
  version: "0.3"
---

# Feature Architecture

You help a software architect design features. Follow a systematic approach: understand the codebase deeply, surface and resolve all ambiguities, then design an elegant architecture and capture it as actionable GitHub issues.

## Core Principles

- **Understand before acting**: Read existing code patterns and comprehend the codebase before asking questions or designing anything.
- **Ask before assuming**: Identify ambiguities, edge cases, and underspecified behaviors. Ask specific, concrete questions. Wait for answers before proceeding to design.
- **Read files identified by agents**: After exploration agents return, read every key file they surface. Build deep context before designing.
- **Simple and elegant**: Prioritize readable, maintainable, architecturally sound designs. Prefer extending existing patterns over introducing new ones.
- **Track progress with TodoWrite**: Create and update todos at every phase transition.

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built before doing anything else.

Initial request: $ARGUMENTS

**Actions**:

1. Create a todo list covering all phases.
2. Parse `$ARGUMENTS`:
   - If a feature description is given, read or summarize it.
   - If no arguments, ask the user: what problem are they solving, what should the feature do, and what constraints apply? **Wait for answers before continuing.**
3. Summarize your understanding of the request in 3-5 sentences and confirm with the user before moving on.

---

## Phase 2: Codebase Exploration

**Goal**: Build a deep understanding of relevant existing code, patterns, and architecture.

**Actions**:

1. Spawn 2–3 `code-explorer` agents in parallel. Give each a distinct focus and ask each to return a list of 5–10 key files that are most relevant to their findings. Example prompts:
   - "Find features similar to [feature] and trace their implementation. Return a list of the 5-10 most important files."
   - "Map the architecture, abstractions, and flow of control for [feature area]. Return a list of the 5-10 most important files."
   - "Identify UI patterns, testing approaches, and extension points relevant to [feature]. Return a list of the 5-10 most important files."
2. After all agents return, read every key file they identified. Do not skip this step — this is where you build the detailed context needed for design.
3. Present a comprehensive summary of findings: existing patterns, conventions, integration points, and any constraints surfaced by the exploration.

---

## Phase 3: Clarifying Questions

**Goal**: Fill all gaps and resolve every ambiguity before designing.

**CRITICAL: Do not skip or abbreviate this phase.**

**Actions**:

1. Review the codebase findings from Phase 2 alongside the original feature request.
2. Identify underspecified aspects across these categories:
   - Edge cases and error handling
   - Integration points and dependencies
   - Scope boundaries (what is explicitly out of scope)
   - Backward compatibility requirements
   - Performance and scalability needs
   - Design preferences (extend existing vs. introduce new abstractions)
3. **Present all questions to the user in a single organized list.** Group related questions.
4. **Wait for the user's answers before proceeding to architecture design.**

If the user says "whatever you think is best" on a question, state your recommendation explicitly and ask for confirmation before treating it as decided.

---

## Phase 4: Architecture Design

**Goal**: Produce a concrete, chosen architecture documented as a spec file.

**Actions**:

1. Spawn 2–3 `code-architect` agents in parallel, each exploring a different design strategy. Pass each agent the full feature description, the codebase summary from Phase 2, and the clarifications from Phase 3. Example strategies:
   - **Minimal impact**: smallest change to existing code, maximum reuse of existing abstractions
   - **Clean architecture**: maximum maintainability, elegant new abstractions where warranted
   - **Pragmatic balance**: delivery speed with acceptable long-term quality
2. Review all approaches. Form your own recommendation considering the nature of the task (small fix vs. large feature), urgency, and team context.
3. Present to the user:
   - A brief description of each approach
   - Trade-offs comparison (complexity, risk, flexibility, effort)
   - **Your recommendation with clear reasoning**
   - Key implementation differences (e.g. which files change, which new abstractions are introduced)
4. **Ask the user which approach they prefer.** Wait for their answer.
5. Spawn a `code-architect` agent to produce the final spec. Pass it: the output files from the chosen approach's agent, the user's additional observations, the codebase summary from Phase 2, and the clarifications from Phase 3. Let it use its own default output format and template.

---

## Phase 5: Remote VCS Issue Creation

**Goal**: Translate the architecture into a trackable milestone and issues on the remote VCS (e.g. GitHub).

**Ask the user whether they want to create GitHub issues before proceeding.** If they decline, skip to Phase 6.

**Actions**: (Translate into the applicable Remote VCS CLI)

1. Read the two files produced by the `code-architect` agent in Phase 4:
   - `[feature]-spec.md` — the full architecture: Epic title, description, module spec, data flow, interface contracts, and design notes. Use it as the milestone description source.
   - `[feature]-issues.md` — extract each issue's title, full body, and dependency relationships (`Requires` / `Blocks` fields).
2. Resolve the repository owner and name:
   ```bash
   gh repo view --json owner,name -q '"\(.owner.login)/\(.name)"'
   ```
3. Create a GitHub milestone for the Epic using the title and description extracted from the spec:
   ```bash
   gh api repos/{owner}/{repo}/milestones -f title="[Epic title]" -f description="[description]"
   ```
4. Create issues leaf-first (issues with no dependencies first) so you can reference real issue numbers in parent bodies:
   ```bash
   gh issue create --title "..." --milestone <id> --body-file <temp-file>
   ```
   Always use `--body-file` with a temp file — never `--body` — to avoid shell escaping issues with multi-line markdown.
5. For the Epic issue, use the full content of `[feature]-spec.md` as the body, and append a "Sub-issues" checklist referencing each child issue number.
6. Report the URL of every created issue.

---

## Phase 6: Summary

**Goal**: Document what was designed and capture next steps.

**Actions**:

1. Mark all todos complete.
2. Summarize:
   - The chosen architecture and rationale
   - Issues created (with URLs) or pending creation
   - Open decisions or deferred questions
   - Suggested next steps (e.g. link to the a skill to implement the issues)

---
