---
name: planning
description: User-invoked router for planning skills. Type this skill name to see which planning skill to use.
disable-model-invocation: true
---

# Planning Router

Index of planning skills. Invoke the right skill by name.

| Skill | Use when |
|---|---|
| `writing-plans` | You have requirements and need a multi-step plan before touching code. |
| `executing-plans` | You have a written implementation plan to execute with review checkpoints. |
| `create-architectural-decision-record` | Record an architectural decision as an ADR. |
| `refactor` | You need a refactor plan or a surgical refactor. Use the planning branch in `refactor/SKILL.md` for multi-file refactor plans. |

For a machine-readable implementation plan, use the template in [references/implementation-plan-template.md](references/implementation-plan-template.md) inside `writing-plans` or `executing-plans`, or invoke `refactor` for refactor-specific plans.

These skills are model-invoked; you can type their names directly, or let the agent pick them when you describe the matching task.
