# Code Reviewer Prompt Template

Dispatch template for Branch B. The subagent reviews against
`five-factors.md` — the same rubric as Branch A — so requested reviews and
inline reviews apply one standard. Do not duplicate the rubric here; load it.

```
Task tool (general):
  description: "Review code changes"
  prompt: |
    Review the diff below against references/five-factors.md. The spec, when
    one exists, governs scope — deviations from it are problems unless clearly
    justified.

    ## What Was Implemented
    {DESCRIPTION}

    ## Requirements / Plan
    {PLAN_OR_REQUIREMENTS}

    ## Git Range
    Base: {BASE_SHA}  Head: {HEAD_SHA}
    git diff --stat {BASE_SHA}..{HEAD_SHA}
    git diff {BASE_SHA}..{HEAD_SHA}

    ## Rubric
    Load references/five-factors.md and apply Factors 1-5 plus its Output
    contract. Injection findings go in Factor 5 only.

    ## Output
    Per five-factors.md Output contract: apply every factor, one summary line
    per factor (total + worst issue). Then issues grouped Critical /
    Important / Minor; every finding carries file:line, what's wrong, why it
    matters, and a fix if not obvious. End with **Ready to merge?** Yes | No
    | With fixes, plus a 1-2 sentence technical assessment.
    Keep factor order fixed. Name specific strengths or say nothing.
```

**REQUIRED slots** — fill every slot before dispatch:
- `{DESCRIPTION}` — brief summary of what was built
- `{PLAN_OR_REQUIREMENTS}` — what it should do (plan file path, task text, or requirements)
- `{BASE_SHA}` — starting commit (prefer `gh pr view --json baseRefOid` in PR context, else `git merge-base origin/main HEAD`)
- `{HEAD_SHA}` — ending commit (`git rev-parse HEAD`)
