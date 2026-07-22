# Shared Pre-flight Evidence Format

This reference is used by the ML-experimentation and Python-stack skills. Move
it up the information ladder so each skill's pre-flight checklist stays short
and domain-specific, while the evidence contract lives in one place.

A ticked pre-flight box without an `Evidence:` line is a Stop-condition
violation — indistinguishable from skipping the check. Every box must point to
an artifact produced or a decision made this turn (or a prior recorded
decision).

## Row shapes

| Box type | Evidence form | Example |
|---|---|---|
| **Detection** | Tool output that matched a detection table + the matched signal | `ls project_root` → `pixi.toml present → pixi` |
| **Gate (G-*)** | `AskUserQuestion id=<id>, answer=<option>` OR prior `JOURNAL.md` Status row | `AskUserQuestion id=abc, answer=pixi` |
| **Workspace decision** | Cite `JOURNAL.md` Status block + recorded date | `JOURNAL.md Status (Workspace decisions, 2026-07-12)` |
| **Tool command** | The command + result | `pixi run ruff check src` → exit 0 |
| **Read/Write artifact** | File path + action | `Read experiments/01_baseline.py` |
| **n/a** | Explicit reason why the box doesn't apply | `n/a — pip+venv project, no feature scopes` |

## Re-emission rule

The last box in every pre-flight is `Pre-flight re-emitted with evidence`. It
is checked only when the agent's final message contains the same pre-flight
block with every `Evidence:` cell filled.

## Per-skill checklists

Each consuming skill keeps its own checklist (its domain boxes), but the
`Evidence:` format is governed by this file. Don't redefine the evidence shape
inside a skill body; point here instead.
