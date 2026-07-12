---
name: ponytail-audit
disable-model-invocation: true
description: "Deprecated alias. Use /ponytail-tools audit instead."
---

Scan the whole tree instead of a diff. Rank findings biggest cut first.

## Tags

Use the same tags as `ponytail-review` (`delete:`, `stdlib:`, `native:`, `yagni:`, `shrink:`).

## Hunt

Deps the stdlib or platform already ships, single-implementation interfaces,
factories with one product, wrappers that only delegate, files exporting one
thing, dead flags and config, hand-rolled stdlib.

## Output

One line per finding, ranked: `<tag> <what to cut>. <replacement>. [path]`.
End with `net: -<N> lines, -<M> deps possible.` Nothing to cut: `Lean already. Ship.`

## Boundaries

Scope: over-engineering and complexity only. Correctness bugs, security holes,
and performance are explicitly out of scope. Route them to a normal review
pass. Lists findings, applies nothing. One-shot.
"stop ponytail-audit" or "normal mode" to revert.
