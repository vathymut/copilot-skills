# Code Reviewer Prompt Template

Dispatch template for Branch B. The subagent reviews with the same five-factor
rubric as Branch A, so requested reviews and inline reviews apply one standard.

```
Task tool (general):
  description: "Review code changes"
  prompt: |
    Review the diff below against the five factors. The spec, when one
    exists, governs scope — deviations from it are problems unless clearly
    justified.

    ## What Was Implemented
    {DESCRIPTION}

    ## Requirements / Plan
    {PLAN_OR_REQUIREMENTS}

    ## Git Range
    Base: {BASE_SHA}  Head: {HEAD_SHA}
    git diff --stat {BASE_SHA}..{HEAD_SHA}
    git diff {BASE_SHA}..{HEAD_SHA}

    ## Five-Factor Rubric
    1. Code Conventions — style and known smells (mysterious name, duplicated
       code, feature envy, data clumps, primitive obsession, repeated switches,
       shotgun surgery, speculative generality, message chains, middle man).
       Skip what tooling already enforces.
    2. Spec Alignment — requirements missing or partial; behaviour not asked
       for (scope creep); implementation that looks wrong (quote the spec).
       No spec available → skip this factor.
    3. Correctness — off-by-one and boundary errors in ranges; unhandled error
       paths or silent failures; wrong data types or implicit casts that lose
       precision; race conditions or shared-mutation bugs.
    4. Maintainability — code-judo: can branches or layers be deleted rather
       than modified? Deletion test: does each abstraction earn its keep?
       Shallow modules, poor locality, files crossing 1000 lines, new
       conditionals in unrelated paths, wrappers/casts/optionals hiding a
       simpler boundary, feature logic in the wrong layer, AI slop (verbose
       comments, defensive bloat, broad `except Exception`). Be ambitious —
       flag restructuring that simplifies. Report; do not implement.
    5. Security & Performance — secrets in the diff; SQL or command injection;
       missing input validation; unnecessary allocations, N+1 queries,
       loop-invariant work; missing caching on repeated expensive operations.

    ## Output
    Per factor: one summary line (total + worst issue). Then issues grouped
    Critical / Important / Minor; each with file:line, what's wrong, why it
    matters, and a fix if not obvious. End with **Ready to merge?** Yes | No |
    With fixes, plus a 1-2 sentence technical assessment.
    Do not merge or rerank findings across factors. Acknowledge specific
    strengths only — no performative praise.
```

**Placeholders:**
- `{DESCRIPTION}` — brief summary of what was built
- `{PLAN_OR_REQUIREMENTS}` — what it should do (plan file path, task text, or requirements)
- `{BASE_SHA}` — starting commit
- `{HEAD_SHA}` — ending commit
