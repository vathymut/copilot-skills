---
name: implement
description: "Implement work from a spec or set of tickets. Use after planning is complete and the user says implement / build / code it. For executing an already-written multi-step plan, prefer executing-plans or subagent-driven-development; for throwaway design exploration, use prototype."
disable-model-invocation: true
---

Implement the work described by the user.

## Rules

- Work in vertical slices. One slice → testable behavior → next slice.
- Use `/test-driven-development` at pre-agreed seams where it fits naturally.
- Run typechecks and single-test files regularly; run the full suite once at the end.
- `/code-review` the result before declaring done.
- Commit the work to the current branch.

## Completion criteria

- [ ] Spec/ticket requirements are implemented.
- [ ] Tests pass and types check.
- [ ] Code has been reviewed.
