# SPECIFICATION

> The complete format specification for Agent Skills.

## Directory structure

A skill is a directory containing, at minimum, a `SKILL.md` file:

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
├── assets/           # Optional: templates, resources
└── ...               # Any additional files or directories
```

## `SKILL.md` specification

The `SKILL.md` file must contain YAML `frontmatter` followed by the `body` markdown content.

See @assets/skill-md-format.md for a `SKILL.md` template.

### Frontmatter

| Field           | Required | Specification                                                                                                       |
| --------------- | -------- | ----------------------------------------------------------------------------------------------------------------- |
| `name`          | Yes      | Display name for the skill. Must match the parent directory name. Must be 1-64 characters. May only contain unicode lowercase alphanumeric characters (`a-z`) and hyphens (`-`). Must not start or end with a hyphen (`-`). Must not contain consecutive hyphens (`--`)            |
| `description`   | Yes      | Should describe both what the skill does and when to use it. Must be 1-1024 characters. Non-empty. Should include pushy specific keywords that help agents identify relevant tasks.                                 |
| `license`       | No       | Should Specify the license applied to the skill: Either the name of a license or the name of a bundled license file.                                                             |
| `compatibility` | No       | Must be 1-500 characters. Should only be included if your skill has specific environment requirements (intended product, system packages, network access, etc.). |
| `metadata`      | No       | Should contain arbitrary key-value mapping for additional metadata.                                                              |
| `arguments`                | No          | Should be set when named positional arguments for [`$name` substitution](#available-string-substitutions) is expected in the skill content. Accepts a space-separated string or a YAML list. Names map to argument positions in order.                                                                                                             |
| `disable-model-invocation` | No          | Should be set to `true` to prevent Claude from automatically loading this skill. Use when user wants to trigger the skill manually with `/name`. Defaults to `false`. |
| `user-invocable`           | No          | Should be set to `false` for background knowledge users shouldn't invoke directly. Defaults: `true`. |
| `allowed-tools` | No       | Should be a space-separated string of pre-approved tools the skill may use. Tools include Bash, Agent, MCP,                                    |
| `context`                  | No          | Should be set to `fork` to run a forked subagent context in isolation. only makes sense for skills with explicit instructions and when access to conversation history is not needed. |
| `agent`                    | No          | Defaults to `general-purpose`. Options include `Explore` and `Plan`. May be set to specify which subagent type to use when `context: fork` is set. |

#### Examples

##### `name` field

<Card>

  **Valid examples:**

  ```yaml
  name: pdf-processing
  ```

  ```yaml
  name: data-analysis
  ```

  ```yaml
  name: code-review
  ```

  **Invalid examples:**

  ```yaml
  name: PDF-Processing  # uppercase not allowed
  ```

  ```yaml
  name: -pdf  # cannot start with hyphen
  ```

  ```yaml
  name: pdf--processing  # consecutive hyphens not allowed
  ```
</Card>

##### `description` field

<Card>

  **Good example:**

  ```yaml
  description: Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when the user mentions PDFs, forms, or document extraction.
  ```

  **Poor example:**

  ```yaml
  description: Helps with PDFs.
  ```
</Card>

##### `license` field

<Card>

  ```yaml
  license: Proprietary. LICENSE.txt has complete terms
  ```
</Card>

##### `compatibility` field

<Card>

  ```yaml
  compatibility: Designed for Claude Code (or similar products)
  ```

  ```yaml
  compatibility: Requires git, docker, jq, and access to the internet
  ```

  ```yaml
  compatibility: Requires Python 3.14+ and uv
  ```
</Card>

<Note>
  Most skills do not need the `compatibility` field.
</Note>

<Card>

##### `metadata` field

<Card>

  ```yaml theme={null}
  metadata:
    author: example-org
    version: "1.0"
  ```
</Card>

##### `allowed-tools` field

<Card>

  ```yaml
  allowed-tools: Bash(git:*) Bash(jq:*) Read
  ```
</Card>

### Body

The `body` after the [`frontmatter`](#frontmatter) contains the skill instructions. There are no format restrictions. Write whatever helps agents perform the task effectively.
Recommended sections:
- Step-by-step instructions
- Examples of inputs and outputs
- Common edge cases

The markdown body content should not exceed 500 lines.

## Optional directories

### `scripts/` 

Put here executable code that agents can run. Scripts should:

* Be self-contained or clearly document dependencies
* Include helpful error messages
* Handle edge cases gracefully

Supported languages depend on the agent implementation. Common options include Python, Bash, and JavaScript.

### `assets/`

Put in this folder static resources like:

* Templates (document templates, configuration templates)
* Images (diagrams, examples)
* Data files (lookup tables, schemas)

### `references/`

Put here additional documentation that agents can read when needed:

* `REFERENCE.md` - Detailed technical reference
* `FORMS.md` - Form templates or structured data formats
* Domain-specific files (`finance.md`, `legal.md`, etc.)

Keep individual reference files focused. Agents load these on demand, so smaller files mean less use of context.

Use `@path/to/file` syntax to reference files. `@path/to/dir/` list directory content.

Populate `scripts/` and `references/` as you enforce [progressive disclosure](#progressive-disclosure) to keep [`SKILL.md`](#skillmd-format) lean and under 500 lines.


# SKILL WRITING GUIDANCE

## Writing effective `description`

When writing the `description`:
1. **Use imperative phrasing**. Frame the description as an instruction to the agent: “Use this skill when…” rather than “This skill does…” The agent is deciding whether to act, so tell it when to act.
2. **Focus on user intent, not implementation**. Describe what the user is trying to achieve, not the skill’s internal mechanics. The agent matches against what the user asked for.
3. **Err on the side of being pushy**. Explicitly list contexts where the skill applies, including cases where the user doesn’t name the domain directly: **“even if they don’t explicitly mention ‘CSV’ or ‘analysis.’”**

## Writing style

1. **Explain the why behind instructions** — LLMs respond better to reasoning than rigid rules
2. **Avoid ALWAYS/NEVER in all caps when you can explain the reason instead**
3. **Use theory of mind**— make instructions general, not over-fit to specific examples
4. **Draft first, then review with fresh eyes**.
5. **Keep the prompt lean**: remove anything that isn't pulling its weight

## Progressive disclosure

Agents load skills *progressively*, pulling in more detail only as a task calls for it. Skills should be structured to take advantage of this:

1. **Metadata** (\~100 tokens): The `name` and `description` fields in the `frontmatter` are always loaded at startup for all skills.
2. **Instructions** (\< 5000 tokens recommended): The full `SKILL.md` `body` is loaded when the skill is activated
3. **Resources** (as needed): Files (e.g. those in `references/` or `assets/`) are loaded only when required. Scripts in `scripts/` can execute without loading.

Keep your main `SKILL.md` `body` lean and under 500 lines. If approaching 500 lines:
- Keep high-level instructions and steps in `SKILL.md` 
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
2. **Be prescriptive when operations are fragile**, consistency matters, or a specific sequence must be followed.
3. **Give the agent freedom when multiple approaches are valid and the task tolerates variation**. For flexible instructions, explaining why can be more effective than rigid directives.
4. **Provide defaults, not menus**. When multiple tools or approaches could work, **pick a default**.
5. **Favor procedures over declarations**. A skill should teach the agent *how to approach a class of problems*, NOT what to produce for a specific instance. 
6. **Favor Templates for output format**. When you need the agent to produce output in a specific format, **PROVIDE A TEMPLATE**. Store them in `assets/` and reference them from `SKILL.md` using `@-mention` syntax so they only load when needed.
7. **Use Checklists for multi-step workflows**. An explicit checklist helps the agent track progress and avoid skipping steps, especially when steps have dependencies or validation gates.
8. **Add `Gotchas` sections in `SKILL.md`**. The highest-value content in many skills is a list of gotchas — environment-specific facts that defy reasonable assumptions. These aren’t general advice (“handle errors appropriately”) but concrete corrections to mistakes the agent will make without being told otherwise. **Keep gotchas in SKILL.md **where the agent reads them before encountering the situation
9. **Include examples**. It's useful to include examples. You can format them like this (but if "Input" and "Output" are in the examples you might want to deviate a little):

```markdown
## Commit message format

**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

## Triggering procedure

`SKILL.md` `description` is the primary triggering mechanism. Include both what the skill does and specific contexts for when to use it in `description`.

**Claude tends to undertrigger skills, so make `description` "pushy"**.

> Weak: "How to build a simple fast dashboard to display internal data."

> Better: "How to build a simple fast dashboard to display internal data. Use whenever the user mentions dashboards, data visualization, internal metrics, or wants to display company data, even if they don't explicitly ask for a 'dashboard'."

## Principle of least surprise

Skills MUST NOT contain malware, exploit code, or content that would surprise the user if described. 

Don't create misleading skills or skills designed to facilitate unauthorized access or data exfiltration.

## Available string substitutions

Use string substitution for dynamic values in the skill content when useful:

| Variable | Description |
|:--|:--|
| `$ARGUMENTS` | All arguments passed when invoking the skill. If absent from content, appended as `ARGUMENTS: <value>`. |
| `$ARGUMENTS[N]` | Nth argument (0-based). |
| `$N` | Shorthand for `$ARGUMENTS[N]`. |
| `$name` | Named argument declared in the `arguments` `frontmatter` list. Names map to positions in order, so with `arguments: [issue, branch]` the placeholder `$issue` expands to the first argument and `$branch` to the second. |
| `${CLAUDE_SESSION_ID}` | Current session ID. Usefull for logging, session-specific files, or output correlation. |
| `${CLAUDE_SKILL_DIR}` | Directory containing the skill's `SKILL.md`. |

Wrap multi-word values in quotes: `/my-skill "hello world" second` → `$0` = `hello world`, `$1` = `second`.

<Card>

**Example using substitutions:**

```yaml SKILL.md
---
name: session-logger
description: Log activity for this session
---

Log the following to logs/${CLAUDE_SESSION_ID}.log:

$ARGUMENTS
```
</Card>

## Dynamic context injection

Use the `` !`<command>` `` syntax to run shell commands before the skill content is sent to Claude. The command output replaces the placeholder, so Claude receives actual data, not the command itself.

See the Complete `SKILL.md` example for an example of dynamic context injection.