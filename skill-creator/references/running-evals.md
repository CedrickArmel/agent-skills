# Running and Evaluating Test Cases

This is one continuous sequence — do not stop partway through. Do NOT use `/skill-test` or any other testing skill.

## Instructions

### Step 0 - Workspace layout

Before writing any eval files, read @assets/workspace-structure.md for the workspace layout if you haven't yet.

Create directories as you go — not all upfront.

### Step 1 — Spawn all runs in the same turn

For each test case:

1. spawn two subagents in the same turn — one with the skill called `with-skill`, one without called `baseline`. DO NOT spawn `with-skill` first and come back for `baseline` later. 

#### `with-skill` run prompt

Here’s an example of the instructions you’d give the agent for a single `with-skill` run:

```markdown
Execute this task:

* Skill path: <path-to-skill>
* Task: <eval prompt>
* Input files: <eval files if any, or "none">
* Save outputs to: <skill-name>-workspace/iteration-<N>/eval-<ID>-<eval-name>/with_skill/outputs/
* Outputs to save: <what the user cares about>
```

#### `baseline` run 

Here’s an example of the instructions you’d give the agent for a single `baseline` run:

##### **New skill**

When creating a new skill from scratch, use the same prompt as `with-skill` run but without the skill path, saving to <skill-name>-workspace/iteration-<N>/eval-<ID>-<eval-name>/without_skill/outputs/

```markdown
Execute this task:

* Task: <eval prompt>
* Input files: <eval files if any, or "none">
* Save outputs to: <skill-name>-workspace/iteration-<N>/eval-<ID>-<eval-name>/without_skill/outputs/
* Outputs to save: <what the user cares about>
```
##### **Improving existing skill**

When improving an existing skill, use the previous version as your baseline:
1. Snapshot the old version first : `cp -r <skill-path> <skill-name>-workspace>/skill-snapshot/`)
2. point baseline at the snapshot, save to  <skill-name>-workspace/iteration-<N>/eval-<ID>-<eval-name>/old_skill/outputs/

```markdown
Execute this task:
* Skill path: <skill-name>-workspace>/skill-snapshot/
* Task: <eval prompt>
* Input files: <eval files if any, or "none">
* Save outputs to: <skill-name>-workspace/iteration-<N>/eval-<ID>-<eval-name>/old_skill/outputs/
* Outputs to save: <what the user cares about>
```

Write `eval_metadata.json` for each test case. Keep `assertions` empty for Now. See @assets/schema-evals-json.md for the schema.

### Step 2 — Draft assertions

While runs are in progress:

1. Draft assertions for each test case and explain them to the user. If assertions already exist in `evals/evals.json`, review and explain those.
2. Update `eval_metadata.json` files and `evals/evals.json` with the assertions. Also explain what the user will see in the viewer.

<Card>

**Good assertions**:

* "The output file is valid JSON" — programmatically verifiable.
* "The bar chart has labeled axes" — specific and observable.
* "The report includes at least 3 recommendations" — countable.

**Weak assertions**:

* "The output is good" — too vague to grade.
* "The output uses exactly the phrase 'Total Revenue: $X'" — too brittle; correct output with different wording would fail.

</Card>


### Step 3 — Capture timing data as runs complete

When each subagent completes, you receive a notification with `total_tokens` and `duration_ms`. SAVE IMMEDIATELY to `timing.json` in the run directory. This is the only opportunity to capture this data.

### Step 4 — Grade each run

1. Spawn a grader subagent or grade inline. Use the instruction in @agents/grader.md.
2. For assertions that can be checked programmatically, write and run a script.
3. Save to `grading.json` in each run directory.

### Step 5 -  Aggregate

* Run the following bash command:

```bash
python -m scripts.aggregate_benchmark <skill-name>-workspace/iteration-N --skill-name <name>
```

This produces `benchmark.json` and `benchmark.md`. Put each with_skill version before its baseline counterpart.

* Spawn a subagent with instruction in @agents/analyzer.md and surface patterns the aggregate stats hide: non-discriminating assertions, high-variance evals, time/token tradeoffs

### Step 6 - Launch the viewer

Run the following bash command:

```bash
nohup python <skill-creator-path>/eval-viewer/generate_review.py \
  <workspace>/iteration-N \
  --skill-name "my-skill" \
  --benchmark <workspace>/iteration-N/benchmark.json \
  > /dev/null 2>&1 &
VIEWER_PID=$!
```

Note: For iteration 2+, also pass `--previous-workspace <workspace>/iteration-<N-1>`.

Note: Headless / Cowork: use `--static <output_path>` to write a standalone HTML file instead of starting a server.

IMPORTANT: Generate the eval viewer BEFORE evaluating inputs yourself. Get outputs in front of the human first.

### Step 7 — Read feedback

Tell the user: "I've opened the results in your browser. The 'Outputs' tab lets you review each test case and leave feedback; the 'Benchmark' tab shows the quantitative comparison. Come back when you're done."

When done, read feedback.json:

```json
{
  "reviews": [
    {"run_id": "eval-0-with_skill", "feedback": "the chart is missing axis labels"},
    {"run_id": "eval-1-with_skill", "feedback": ""},
    {"run_id": "eval-2-with_skill", "feedback": "perfect, love this"}
  ],
  "status": "complete"
}
```

Empty feedback = the user thought it was fine. Focus improvements on cases with specific complaints.

Kill the viewer when done:

```bash
kill $VIEWER_PID 2>/dev/null
```
