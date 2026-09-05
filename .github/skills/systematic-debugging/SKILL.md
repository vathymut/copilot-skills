---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

## When NOT to use

- Greenfield feature with no bug — use `test-driven-development` (with `ponytail` for scope).
- Proactive code review — use `code-review`.

# Systematic Debugging

**Core principle:** Find root cause before attempting fixes. Symptom fixes are failure.

**The Iron Law:** NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.

Use for ANY technical issue: test failures, bugs, unexpected behavior, performance, builds, integration. Especially under time pressure, when a "quick fix" seems obvious, or when previous fixes didn't work. Don't skip: simple bugs have root causes too; rushing guarantees rework.

## The Four Phases

Complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**Objective:** Understand what and why before any fix.

1. Read error messages carefully — stack traces, line numbers, codes.
2. Reproduce consistently — exact steps, every time? Not reproducible → gather data, don't guess.
3. Check recent changes — git diff, commits, deps, config, environment.
4. Gather evidence in multi-component systems — for each boundary, log what enters/exits, verify propagation. Reveals which layer fails.
   ```bash
   # For each component boundary: log input → check env → log output → verify propagation
   echo "=== <layer>: <what> ==="; command_to_check
   ```
5. Trace data flow backward — where does bad value originate? Fix at source, not symptom.

**Done:** You can state the root cause and why it produces the symptom.

### Phase 2: Pattern Analysis

**Objective:** Identify differences between working and broken.

1. Find similar working code in the same codebase.
2. Compare against references — read completely, don't skim.
3. List every difference between working and broken — "that can't matter" is not a valid filter.
4. Understand dependencies — components, config, environment, assumptions.

**Done:** You have a list of differences, one of which is the likely cause.

### Phase 3: Hypothesis and Testing

**Objective:** Confirm or disprove with minimal change.

1. Form single hypothesis: "I think X is root cause because Y."
2. Test minimally — smallest possible change, one variable at a time.
3. Verify before continuing. Worked → Phase 4. Didn't work → new hypothesis.
4. Don't know? Say "I don't understand X" and ask/research.

**Done:** Hypothesis confirmed, or you know what additional information you need.

### Phase 4: Implementation

**Objective:** Fix root cause, not symptom, with verification.

1. Create failing test case (simplest reproduction) before fixing. Use `test-driven-development` — this RED precedes any fix code from Phases 1-3; delete speculative patches before the TDD cycle.
2. Implement single fix — one change, no "while I'm here" improvements.
3. Verify fix — test passes, no other tests broken.
4. If fix doesn't work: < 3 attempts → return to Phase 1. ≥ 3 → STOP and question architecture (is the pattern sound, or are you fixing symptoms of a wrong design?). Discuss with your human partner.

**Done:** Bug resolved, test passes, no regressions.

## Red Flags — STOP, return to Phase 1

- "Quick fix for now, investigate later" / "Just try changing X" / "Add multiple changes, run tests"
- Proposing solutions before tracing data flow
- "One more fix attempt" (≥2 already tried)
- Each fix reveals a new problem in a different place
- Human partner says: "Is that not happening?" / "Will it show us...?" / "Stop guessing" / "Ultrathink this"

## Evidence template (Phase 1 Done)

Before leaving Phase 1, record:

```
Root cause: <file:line + function> — <why it produces symptom>
Repro: <command or steps> — <consistent? yes/no>
Boundary logs: <layer>: in=<...> out=<...> propagated=<yes/no>
```

Keep it to 4 lines. If you can't fill it, you haven't finished Phase 1.

## When "No Root Cause" Found

Document investigation, implement handling (retry, timeout, error message), add monitoring. But 95% of "no root cause" is incomplete investigation.

## Completion criteria

- [ ] Root cause stated with file:line and causal chain to symptom
- [ ] Reproduction steps recorded (or evidence that it's non-reproducible and why)
- [ ] Hypothesis tested with single-variable minimal change
- [ ] Fix verified via failing-test-first (`test-driven-development`) and no regressions

## Supporting techniques

- `references/root-cause-tracing.md` — backward call-stack tracing
- `references/defense-in-depth.md` — validation at multiple layers
- `references/condition-based-waiting.md` — replace timeouts with polling
- `test-driven-development` — failing test creation (Phase 4.1)
- `test-driven-development:references/verify-before-claiming.md` — evidence before success claim

## Related skills

- `test-driven-development` — failing-test-first fix at Phase 4.
- `refactor` — reshape after root cause fixed.
- `ponytail` — minimal fix at shared function (not per caller).
