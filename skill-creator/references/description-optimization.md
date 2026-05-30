# Description Optimization

The `description` field is the primary mechanism determining whether Claude invokes a skill. After the skill is in good shape, optimize it for better triggering accuracy.

## Step 1 — Generate trigger eval queries

Create 16-20 eval queries — a mix of 8-10 `should-trigger` and 8-10 `should-not-trigger`. save the generated content to JSON.

See @assets/schema-eval-queries-json.md for how to format the JSON.

* `should-trigger` queries: Different phrasings of the same intent — formal and casual. Include cases where the user doesn't name the skill but clearly needs it. Uncommon use cases. Cases where this skill competes with another but should win.
* `should-not-trigger` queries: Near-misses — queries sharing keywords but needing something different. Adjacent domains, ambiguous phrasing, cases where a naive keyword match would trigger but shouldn't. Make them genuinely tricky, not obviously irrelevant.

Queries should be realistic and concrete — not abstract requests. Include file paths, personal context, column names, company names, a little backstory. Mix lengths. Focus on edge cases, not clear-cut cases.

<Card>

**Bad**: Format this data", "Extract text from PDF

**Good**: ok so my boss just sent me this xlsx file (Q4 sales final FINAL v2.xlsx) and she wants me to add a column for profit margin. Revenue is column C, costs are column D i think

</Card>


## Step 2 — Review with user

1. Read the template from @assets/eval_review.html
2. Replace __EVAL_DATA_PLACEHOLDER__ with the JSON array, __SKILL_NAME_PLACEHOLDER__ and __SKILL_DESCRIPTION_PLACEHOLDER__
3. Write to `/tmp/eval_review_<skill-name>.html` and open it. The user can edit queries, toggle `should-trigger`, add/remove entries, then click `Export Eval Set`
4. Check ~/Downloads/ for the most recent `eval_set.json`

## Step 3 — Run the optimization loop

1. Tell the user this will take some time and you'll run it in the background.
2. Save the eval set to the workspace, then:

```bash
python -m scripts.run_loop \
  --eval-set <path-to-trigger-eval.json> \
  --skill-path <path-to-skill> \
  --model <model-id-powering-this-session> \
  --max-iterations 5 \
  --verbose
```

The script returns JSON with best_description — selected by test score to avoid overfitting.

Use the model ID from your system prompt so the triggering test matches what the user actually experiences.

Periodically tail the output to give the user iteration updates and scores.

## Step 4 — Apply the result

Take best_description from the JSON output, update `SKILL.md` frontmatter.

Show the user before/after and report the scores.
