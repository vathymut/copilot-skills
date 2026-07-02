# Forbidden Shortcuts — iterate-ml-experiment

Reference companion. Rules enforced in stop conditions are the
source of truth; this table spells out the common violations
verbatim so the agent can recognise them on sight.

## Table

| Shortcut | Why it's wrong |
|---|---|
| User said "quick baseline" → skip G-DESIGN | G-DESIGN is non-negotiable; "quick" never waives it. The design note is the postmortem's frozen Method |
| Scaffold + implement in one turn before G-DESIGN | Inverts the contract. Code that lands before approval has no Motivation/Risks the user signed off on |
| Skipped `evaluate-ml-pipeline` because `KFold(5)` "feels right" | Even empty `split_kwargs` is a justified pick the skill exists to surface. Bypass = user never got the choice |
| Bootstrap mode → skip ALL questions, not just the sourcing menu | Bootstrap forbids the sourcing menu only. G-PKG-NAME / G-ENV-MGR / G-TABULAR / G-SKORE-MODE / G-EDA / G-DESIGN / G-CV-SPLITTER / G-RUN still fire |
| Ambiguous "hmm interesting" / "I guess" read as approval | Approval is explicit. Ambiguity → re-ask, never silent yes |
| Auto-detect run finished via `reports/` mtime | § 4 is user-triggered (v1). The skill never auto-records |
| § 4 finishes recording → declare done, skip audit dispatch | § 4 audit dispatch is part of record-outcome, not optional. The audit digest carries the headline metrics for the JOURNAL row |
| Run experiment in same turn as G-RUN → declare done without § 4 | § 4 follows G-RUN in the same turn when the run completes successfully. Don't stop at "I ran it" — record the outcome |
| Pre-read every sibling SKILL.md file at session start | Read-set tracker is not a blocking gate. Open siblings just-in-time; emit pending list but proceed |
