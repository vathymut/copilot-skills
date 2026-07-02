---
name: thermo-nuclear-code-quality-review
description: 'Run an extremely strict maintainability review for abstraction quality, giant files, and spaghetti-condition growth.'
---

# Thermo-Nuclear Code Quality Review

Use this skill for an unusually strict review focused on implementation quality, maintainability, abstraction quality, and codebase health.

Above all, this skill should push the reviewer to be **ambitious** about code structure. Do not merely identify local cleanup opportunities. Actively search for "code judo" moves: restructurings that preserve behavior while making the implementation dramatically simpler, smaller, more direct, and more elegant.

## Procedure

1. Obtain the diff or code changes to be reviewed.
2. Cross-reference the changes with the rules provided in [guidelines.md](./references/guidelines.md).
3. Identify structural regressions and missed opportunities for simplification ("code judo" moves).
4. Evaluate file size and coupling (e.g., pushed over 1k lines without decomposition).
5. Compile high-conviction, actionable feedback focusing on structural issues rather than minor cosmetic nits.
6. Provide a rigorous assessment against the approval bar specified in the guidelines.

## References

- [Thermo-Nuclear Code Quality Review Guidelines](./references/guidelines.md)

