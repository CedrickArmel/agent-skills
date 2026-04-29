# Specification

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

## `SKILL.md` format

The `SKILL.md` file must contain YAML `frontmatter` followed by the `body` markdown content.

### Frontmatter

| Field           | Required | Constraints                                                                                                       |
| --------------- | -------- | ----------------------------------------------------------------------------------------------------------------- |
| `name`          | Yes      | Must match the parent directory name. Must be 1-64 characters. May only contain unicode lowercase alphanumeric characters (`a-z`) and hyphens (`-`). Must not start or end with a hyphen (`-`). Must not contain consecutive hyphens (`--`)            |
| `description`   | Yes      | Must be 1-1024 characters. Non-empty. Should describe both what the skill does and when to use it. Should include specific keywords that help agents identify relevant tasks.                                 |
| `license`       | No       | Should Specify the license applied to the skill: Either the name of a license or the name of a bundled license file.                                                             |
| `compatibility` | No       | Must be 1-500 characters. Should only be included if your skill has specific environment requirements (intended product, system packages, network access, etc.). |
| `metadata`      | No       | Should contain arbitrary key-value mapping for additional metadata.                                                              |
| `allowed-tools` | No       | Should be a space-separated string of pre-approved tools the skill may use. (Experimental)                                    |

<Card>

  **Minimal example:**

  ```markdown SKILL.md
  ---
  name: skill-name
  description: A description of what this skill does and when to use it.
  ---
  ```

  **Example with optional fields:**

  ```markdown SKILL.md
  ---
  name: pdf-processing
  description: Extract PDF text, fill forms, merge files. Use when handling PDFs.
  license: Apache-2.0
  metadata:
    author: example-org
    version: "1.0"
  ---
  ```
</Card>

### Body

The `body` after the `frontmatter` contains the skill instructions. There are no format restrictions. Write whatever helps agents perform the task effectively.
Recommended sections:
- Step-by-step instructions
- Examples of inputs and outputs
- Common edge cases

Keep the markdown body content should not exceed 500 lines.

## Optional directories

### `scripts/` 

Contains executable code that agents can run. Scripts should:

* Be self-contained or clearly document dependencies
* Include helpful error messages
* Handle edge cases gracefully

Supported languages depend on the agent implementation. Common options include Python, Bash, and JavaScript.

### `assets/`

Contains static resources:

* Templates (document templates, configuration templates)
* Images (diagrams, examples)
* Data files (lookup tables, schemas)

### `references/`

Contains additional documentation that agents can read when needed:

* `REFERENCE.md` - Detailed technical reference
* `FORMS.md` - Form templates or structured data formats
* Domain-specific files (`finance.md`, `legal.md`, etc.)

Keep individual [reference files](#file-references) focused. Agents load these on demand, so smaller files mean less use of context.
