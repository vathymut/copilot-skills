# Skill Eval Workflow

Concise version of the full eval loop. See the archived source
`references/writing-how-to.md` for the full how-to if you need every detail.

## 1. Create evals

Write realistic test prompts to `evals/evals.json`:

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

## 2. Spawn runs in the same turn

For each eval, launch both a with-skill and a baseline subagent.

**With-skill run:**

```
Execute this task:
- Skill path: <path-to-skill>
- Task: <eval prompt>
- Input files: <eval files or "none">
- Save outputs to: <workspace>/iteration-<N>/eval-<ID>/with_skill/outputs/
- Outputs to save: <what the user cares about>
```

**Baseline run:**

- New skill: same prompt, no skill path, save to `without_skill/outputs/`.
- Improved skill: snapshot old skill first, point baseline at snapshot, save to
  `old_skill/outputs/`.

## 3. Draft assertions while runs execute

Use objectively verifiable checks with clear names. For subjective outputs, rely
on qualitative review instead.

## 4. Capture timing

When each subagent task completes, write `timing.json`:

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332,
  "total_duration_seconds": 23.3
}
```

## 5. Grade, aggregate, and view

1. Grade each run with `grading.json` using fields `text`, `passed`, `evidence`.
2. Aggregate:
   ```bash
   python -m scripts.aggregate_benchmark <workspace>/iteration-N --skill-name <name>
   ```
3. Launch the viewer:
   ```bash
   python <skill-path>/eval-viewer/generate_review.py \
     <workspace>/iteration-N \
     --skill-name "my-skill" \
     --benchmark <workspace>/iteration-N/benchmark.json
   ```

## 6. Iterate

Read `feedback.json`, improve the skill, and run a new iteration.

Stop when the user is happy, feedback is empty, or progress stalls.
