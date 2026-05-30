# Workspace structure

Organize eval results in a workspace directory alongside your skill directory. Put results in `<skill-name>-workspace/` as a sibling to the skill directory. Organize by run (`run-1/`, `run-2/`, etc.), then by test case (`eval-0-<eval-name>/`, etc.). Within that, each eval directory gets `with_skill/` and `without_skill/` subdirectories:

```
<skill-name>/
├── SKILL.md
└── evals/
    └── evals.json
<skill-name>-workspace/
├── .venv/
└── run-N/
    ├── eval-N-top-months-chart/
    │   ├── with_skill/
    │   │   ├── outputs/       # Files produced by the run
    │   │   ├── timing.json    # Tokens and duration
    │   │   └── grading.json   # Assertion results
    │   └── without_skill/
    │       ├── outputs/
    │       ├── timing.json
    │       └── grading.json
    ├── ...
    └── benchmark.json         # Aggregated statistics
```

Create directories as you go — not all upfront.
