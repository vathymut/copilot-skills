# Source from User

Source the next ML experiment proposal from the user — directly, or via
something they've pointed at (article, issue, spec, repo). This is
`iterate-ml-experiment` section § 2b.

## Output contract

Return a single **Proposal block** as conversation text:

```
Proposal (from: user via <article-link | resource-link | free-text>):
  Question:        <one sentence>
  Motivation:      <quote / URL / file path + the why-now reason>
  Source:          <article URL with claim | gh issue URL | spec file:line | user quote>
  Method outline:  <prose; which file in src/<pkg>/ is touched>
  Open gaps:       <transfer risks, dep questions, domain assertions needing confirmation>
```

Required in every branch:

- All three shaping questions are answered.
- The synthesis confirmation gate has fired and the user said yes.
- `Source` is concrete (URL, file:line, or user quote).

There is no "no proposal" outcome: this section only fires when the user picked
`user` from the sourcing menu.

## Stop conditions

- Don't write `journal/` files.
- Don't infer source content from memory. If the user references an article,
  issue, or file, fetch / read it.
- Confirm before returning. Free-text "hmm" / "maybe" / "interesting" is not
  confirmation.
- Check `gh auth status` before any GitHub fetch.
- Flag goal shifts against `JOURNAL.md` Status before returning.
- Gate new dependencies as `Open gaps`; don't silently add them to the method.
- List domain-specific assertions as `[needs user confirmation]` in `Open gaps`.

## Entry-point AskUserQuestion

Open with `AskUserQuestion` — three mutually exclusive options, no silent default:

- **article-link** — scientific article, blog post, or library doc.
- **resource-link** — GitHub issue, spec file, notes repo, or concrete artifact.
- **free-text** — the user describes an idea directly.

**Exception — pre-resolved entry point.** When `iterate-ml-experiment`
dispatched here after resolving the branch at the sourcing-menu level (URL,
issue link, or concrete idea already in hand), skip this question and go
straight to the matching branch. The synthesis-confirmation gate still fires.

## The three shaping questions

Every Proposal must answer:

1. **What are we trying to learn?**
2. **Why now?**
3. **What changes vs. the previous experiment?**

Missing → ask. Don't fabricate.

## Branches

### Branch A — article-link

1. Fetch with `WebFetch`; search first if only a topic was given.
2. Map to the three shaping questions. Quote the article for "why now?".
3. Surface transfer risks (different modality, dataset size, target type).
4. Flag new dependencies as open gaps.
5. Flag domain assertions as `[needs user confirmation]`.
6. Confirm before returning.

### Branch B — resource-link

The user points at:

- **GitHub issue**: check auth, then `gh issue view <N> --json ...`. Pull the
  most recent ~5 comments if the body is under-specified.
- **Spec / notes file**: `Read` the named file; don't crawl neighbors.
- **Reference repo**: read the named top-level doc only.

**Repo resolution priority** for bare issue numbers:

1. Explicit URL.
2. `org/repo#N` shorthand.
3. Bare `#N` with current `gh` context; ask if none.

Then map to the three shaping questions, cite specifically, and flag gaps.
Confirm before returning.

### Branch C — free-text

1. Walk the three shaping questions in plain language. Quote the user.
2. Treat their words as the `Source`.
3. Confirm before returning.

## Confirm before returning

Emit a plain-text synthesis and wait for explicit approval:

> "From <source>, I understand you'd like to **<one-line intent>** —
> concretely, change `src/<pkg>/<file>.py` to **<method-outline-summary>**.
> Open gaps: **<bullets>**. Does this capture what you want before I hand it to
> the planner?"

- "Yes / confirm / go" → return the Proposal.
- "No / adjust X" → revise and re-confirm.
