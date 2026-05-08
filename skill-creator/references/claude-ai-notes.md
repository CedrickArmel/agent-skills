## Claude.ai

The core workflow (draft → test → review → improve → repeat) is the same, but some mechanics change.

* **Running test cases:** No subagents. For each test case, read the skill's `SKILL.md` and follow its instructions yourself. One at a time. Skip baseline runs.

* **Reviewing results:** If you can't open a browser, skip the viewer. Present results directly in the conversation — show the prompt and output for each test case. For file outputs, save to the filesystem and tell the user where to download. Ask for feedback inline.

* **Benchmarking:** Skip quantitative benchmarking (no baseline comparisons without subagents). Focus on qualitative feedback.

* **Description optimization:** Requires the `claude` CLI (`claude -p`) — only available in Claude Code. Skip on Claude.ai.

* **Blind comparison:** Requires subagents. Skip.

* **Packaging:** `package_skill.py` works anywhere with Python and a filesystem. The user can download the resulting `.skill` file.

* **Updating an existing skill:**
    - Preserve the original name (directory name and `name` frontmatter field — unchanged)
    - Copy to a writeable location before editing: `cp -r <skill-path> /tmp/skill-name/`
    - Package from the copy — direct writes may fail due to permissions