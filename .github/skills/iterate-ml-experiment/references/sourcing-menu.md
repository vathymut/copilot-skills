# §2 Sourcing menu detail (extracted)

Load when you reach § 2 Propose in iterate mode.

### The sourcing menu — surface VERBATIM

Every time § 2 runs in iterate mode, surface this menu with the
Backlog table. **Never silently default.**

```
How would you like me to source the next experiment?

  skore    — read the audit digest; draft Backlog rows, re-present
  user     — article URL, GitHub issue, spec, or free text
  my-pick  — I synthesize 2-4 candidates; you pick one
  B<N>     — promote a Backlog row directly

Backlog (pick by index):
<paste JOURNAL.md Backlog table here>
```

Use `AskUserQuestion` for the pick. Plain-text enumeration only if
unavailable.

### Free-text handling — first match wins

| User said… | Resolves to |
|---|---|
| Exact label / `B2` / "let's do B2" | that pick / `B<N>` |
| Scientific article URL | `user` → article-link |
| GitHub issue URL / spec path | `user` → resource-link |
| "give me ideas" / "you decide" | `my-pick` |
| "let me try X" / "use Y instead" | `user` → free-text |
| Ambiguous / off-menu | fire `AskUserQuestion`, don't guess |
