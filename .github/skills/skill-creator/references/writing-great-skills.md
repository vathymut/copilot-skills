# Writing Great Skills — Concise Reference

A skill exists to wrangle determinism out of a stochastic system. The root virtue
is **Predictability** — the agent taking the same *process* every run.

## Invocation loads

- **Model-invoked skill**: has a description; the agent can fire it and other
  skills can reach it. Pays **context load** on every turn.
- **User-invoked skill**: no description; only the human can reach it by name.
  Pays **cognitive load** on the human.

Split by invocation only when there is a distinct leading word the agent should
trigger on, or when another skill must reach it. Split by sequence only when
later steps tempt premature completion of the current step.

## Information hierarchy (top to bottom)

1. **In-skill steps** — ordered actions; primary tier.
2. **In-skill reference** — definitions, rules.
3. **Disclosed reference** — linked files behind context pointers.

Push reference down the ladder to keep steps legible. Inline what every branch
needs; disclose what only some branches need.

## Steering levers

- **Leading word**: compact concept from the model's priors (e.g. *lesson*,
  *fog of war*, *tracer bullets*). Repeats the token, not the meaning.
- **Completion criterion**: checkable and, where it matters, exhaustive.
- **Legwork**: thoroughness within a step, raised by strong criteria or leading
  words.

## Failure modes

- **Premature completion** — ending a step before it's done. Sharpen the
  completion criterion first; hide later steps only if the criterion is
  irreducibly fuzzy and you actually observe rushing.
- **Duplication** — same meaning in more than one place. Single source of truth.
- **Sediment** — stale layers accumulate because removing feels risky.
- **Sprawl** — skill is simply too long. Push reference behind pointers; split by
  branch or sequence.
- **No-op** — a line that doesn't change behaviour versus the default. Delete it.

## Pruning

For each line ask:

- Is there a single source of truth for this meaning?
- Does the line still bear on what the skill does?
- Is it a no-op versus the default?
- Can it be collapsed into a leading word?

Be aggressive. Most prose that fails these tests should go, not be rewritten.
