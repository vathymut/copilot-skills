# Source from Skore

Read the audit digest at `scratch/audit/<stem>/audit.md`, produced by
`audit-ml-pipeline` at § 4 record-outcome. Output: a set of
**Backlog-candidate rows** + a short human summary, handed back to the parent
`iterate-ml-experiment` section § 2a.

## What this section consumes

The digest carries two sections that matter here:

- `## Checks summary` — a DataFrame whose rows each have `code`, `severity`
  (`passed` / `issue` / `tip`), and `documentation_url`. Each `issue` / `tip`
  row → one Backlog candidate, with the `documentation_url` driving the `Item`
  text.
- `## Metrics summary` — task-appropriate headline metrics. Used to ground the
  human summary paragraph. Does not drive Backlog rows on its own.

Nothing else.

## Why read the digest (not re-walk the Project)

The audit already opened the Project, loaded the report, called the two
accessors, and rendered the output as markdown. Re-doing that work here would
duplicate materialization cost, risk drift, and require an environment this
section should not need. Reading the digest as text is cheaper and
deterministic.

## Output contract

Return two artifacts as conversation text:

1. **Backlog-candidate rows** — one row per actionable check. Each row carries:
   - `Item`: one-line experiment idea derived from the check's
     `documentation_url` content. Phrase as an *experiment idea*, not as a metric
     reading.
   - `Source`: `audit:<stem>:checks.<code>` (e.g.
     `audit:01_baseline:checks.SKD003`).

2. **Summary** — one paragraph: how many findings surfaced, top 2-3 by severity,
   headline metrics for context.

If the parent's Backlog already contains the same `Source` citation, drop the
candidate. Note the number of dropped duplicates in the summary.

### Empty-checks outcome

If the checks summary has no `issue` / `tip` rows, return zero candidates and a
summary saying so explicitly.

### Inaccessible-digest fallback

If the digest cannot be read, return zero rows and explain the access failure.
Do not fabricate findings or re-run probes. Recovery is owned by
`audit-ml-pipeline`.

## Stop conditions

- Don't write `journal/` files.
- Don't re-open the skore Project. Reading the digest is the contract; if it's
  missing, re-execute the audit runner via `audit-ml-pipeline`.
- Only `## Checks summary` rows drive Backlog candidates.
- Follow the `documentation_url` with `WebFetch`; don't invent mitigations.
- Don't pick a single "winning" finding for the user.
- Dedup against existing Backlog rows by `Source` citation.
- Don't author acceptance criteria.
- No Python execution here. Use `Read` and `WebFetch` only.

## Inspection loop

1. Locate the digest for the most recent `done` experiment at
   `scratch/audit/<stem>/audit.md`.
2. Read it as text.
3. Walk `## Checks summary`. For every `issue` / `tip` row:
   - `WebFetch` the `documentation_url`.
   - Draft the `Item` from the page's recommended mitigations, phrased as a
     one-line experiment idea.
   - Citation: `audit:<stem>:checks.<code>`.
4. Dedup against existing Backlog by reading `JOURNAL.md` Backlog.
5. Read `## Metrics summary` for context only.
6. Compose the return block in the format below.

## Return format

```
Backlog candidates (from: audit digest of <prev_stem>):
  - Item:    <one-line experiment idea derived from the docs URL>
    Source:  audit:<prev_stem>:checks.<code>
  ...

Dropped as duplicates (already in Backlog): <N>

Summary:
  <one paragraph — counts, top highlights, headline metrics, doc URLs. Dense.>
```
