## Cowork

* **Subagents:** Available. The main workflow works. If you hit severe timeout issues, run test prompts in series rather than parallel.

* **Browser/display:** Not available. Use `--static <output_path>` with `generate_review.py` to write a standalone HTML file. Proffer a link the user can open in their browser.

* **Eval viewer:** Always generate it — do not skip. GENERATE THE EVAL VIEWER BEFORE evaluating inputs yourself. You want outputs in front of the human ASAP.

* **Feedback:** Since there's no running server, "Submit All Reviews" downloads `feedback.json`. You may need to request access before reading it.

* **Description optimization:** `run_loop.py` / `run_eval.py` work fine (they use `claude -p` via subprocess, not a browser). Save until the skill is fully finished and the user agrees it's in good shape.

* **Packaging:** Works — just needs Python and a filesystem.

* **Updating an existing skill:**
    - Preserve the original name (directory name and `name` frontmatter field — unchanged)
    - Copy to a writeable location before editing: `cp -r <skill-path> /tmp/skill-name/`
    - Package from the copy — direct writes may fail due to permissions