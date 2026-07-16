---
name: data-science-python-stack
description: Use when a Python import fails in a data-science or ML project, or when the stack offers two or more libraries for one job (tabular DL, plotting, serving) and a choice is needed.
---

# Data Science Python Stack

Opinionated stack — one library per job, organized into four tiers
plus an orthogonal **agent feature**:

1. **Mandatory** — installed at project start, no exceptions.
2. **User choice (competing-library jobs)** — multiple valid libraries
   for the same job; the user picks via `AskUserQuestion` before any
   import lands.
3. **Optional** — install only when the project's task requires it.
4. **Transitive** — already pulled in by the mandatory tier; do not
   install explicitly, but know they're available.
5. **Agent feature (orthogonal)** — deps that the *agent* uses
   to audit a workspace and to power the editor LSP integration
   (`ipython`, `pyright`), kept out of the production-shape
   runtime via a manager-specific scope. Install logistics owned
   by `python-env-manager` § "Agent feature"; consumed by
   `evaluate-ml-pipeline` § Audit and the opencode LSP integration.

## Stop conditions — read before naming any library

- **No silent pick on a competing-library job.** Whenever the stack
  offers two or more libraries for the same job (see § "Competing
  libraries — general rule" and the Tier 2 table), the user picks
  via `AskUserQuestion` before any `Write` that imports the library
  and before any install command runs. "Already pulled in
  transitively" / "user said 'quick'" / "the folder has no
  preference signalled" are **not** waivers. A silent pick is a
  Stop-condition violation, full stop.
- **No substitute when import fails.** When code in this stack needs
  a library but `import` fails, install it; do not rewrite to a
  non-stack equivalent (see § "Missing dependency"). The most
  common silent-rewrite path —
  `import skrub` fails → rewrite as `sklearn.Pipeline`,
  `import skore` fails → rewrite as `cross_val_score` —
  silently undoes the workflow skills' contract.
- **Harness hints do not waive gates.** See
  `../references/shared-ml-conventions.md` (Harness hints; Missing
  dependency; Ruff; scratch/ rule) for the single-source wording.
- **Post-hoc audit — required before ending the turn.** Before
  declaring the turn complete, verify each competing-library job
  invoked in this turn has either (a) an `AskUserQuestion` answer
  recorded this session, or (b) a matching row in
  `journal/JOURNAL.md` Status `Workspace decisions`. If any
  competing-library job ran without one of those, surface the
  non-compliance to the user explicitly as part of your final
  message — do not hide it.

## Competing libraries — general rule

This is the meta-rule that governs every "user choice" entry in
this skill. It applies to the Tier 2 table below and to any new
competing-library job added in the future.

### The rule

Whenever the stack offers two or more libraries for the same job:

1. **`AskUserQuestion` before any import or install.** Use the
   options listed for the job in the competing-jobs table.
2. **Persist the answer in `journal/JOURNAL.md` Status under
   `Workspace decisions`.** On future sessions, **read Status
   first**; do not re-ask a recorded decision.
3. **No silent default.** Even when one option is "free"
   (already pulled in transitively) and the other costs an
   install, never pick silently. The picking happens via
   `AskUserQuestion`.

### Free-text resolution

A user message resolves a competing-library gate **only** if it
names one of the listed options for the job:

- **Exact match** to an option label: resolves the gate.
- **Library named in a free-text intent**: resolves the gate.
- **No library named** ("you pick", "whatever", "no preference"):
  does **NOT** resolve. Fall through to `AskUserQuestion`.

### Adding a new contested job

Every row must name an explicit `Default-on-no-preference` — rows
without one are forbidden. If a sensible default cannot be named,
the job does not belong in the table.

## When to invoke this skill

Two events trigger this skill before any other action:

1. **A library import fails** in the stack's domain. The answer is
   install (see § "Missing dependency" below), never substitute.
2. **A library choice has to be made** — for tabular data at project
   start, or any time code is about to introduce a new dependency
   (deep learning, model serving, notebooks, …).

In both cases, **read the whole SKILL.md before deciding**. The tier
structure below determines whether a library should already be
present, needs a user prompt, or is opt-in — that decision can't be
made from a single index entry.

## Missing dependency — install, do not substitute

When code in this stack needs a library but `import` fails, the answer is
**install it**, not substitute. Specifically:

- Surface the missing dependency to the user. **Invoke
  `python-env-manager` to produce the right install command** — don't
  infer it from memory; the project may not use the default manager.
  **Stop and wait for confirmation before doing anything else.**
- Do **not** rewrite the code to use a non-stack equivalent
  (`sklearn.Pipeline` for `skrub`, `cross_val_score` + handwritten
  metric prints for `skore`. Substitution silently breaks the contract
  that the workflow skills (`build-ml-pipeline`,
  `evaluate-ml-pipeline`, `ml-scaffold`) rely on.
- This rule **overrides** "make the code run". If the user prefers a
  substitute, they will say so — until they do, install. Reaching
  for a substitute because the dependency is missing is the most
  common way the stack gets silently undone, so treat the missing
  import as a hard stop.

## How to use this skill

1. Read this whole SKILL.md before picking — the tier structure
   determines whether the library should already be installed, needs
   a user-choice prompt, or is opt-in.
2. Match the task to an entry in the right tier.
3. Read the linked `references/<library>.md` for the chosen library's
   scope and tradeoffs before introducing it.
4. For the actual install command, invoke `python-env-manager`. This
   skill owns *what* and *why*; `python-env-manager` owns *how*.
5. Don't substitute libraries silently. If no entry fits the task,
   surface the tradeoff to the user.

## Library tiers (Tier 1–4)

The full catalog — Tier 1 (mandatory), Tier 2 (competing-library jobs
needing a user choice), Tier 3 (optional, install on demand), and Tier 4
(transitive, do not install) — with per-library scope, tradeoffs, and
`references/<library>.md` links lives in
`references/library-catalog.md`. Load it when you are matching a task to
a library.

**Tier summary (decision, not detail):**

- **Tier 1 — Mandatory:** scikit-learn, skrub, skore, ruff, pytest. The
  first three co-own the modeling workflow; ruff is non-negotiable lint
  + format; pytest backs the `evaluate-ml-pipeline` § Smoke gate.
- **Tier 2 — Competing-library jobs:** user choice required (tabular DL,
  plotting, serving, experiment tracking). See `references/library-catalog.md`
  and the Competing-libraries general rule above.
- **Tier 3 — Optional:** install on demand (e.g. interactive viz,
  reporting).
- **Tier 4 — Transitive:** already pulled in (e.g. by skore); do not
  install explicitly.

## Agent feature — orthogonal to the four tiers

Agent-only tooling (`ipython` + `pyright`) used by
`evaluate-ml-pipeline § Audit` and the editor LSP integration. Not Tier 1–4;
lives in its own manager-scoped bucket.

| Library | Role |
|---|---|
| `ipython` | Powers the in-process cell runner for `# %%` audit files |
| `pyright` | Powers the opencode LSP integration for Python files |

**Install + config: owned by `python-env-manager` § "Agent feature".**
Consumed by `evaluate-ml-pipeline § Audit` and the LSP; routes through
`G-AGENT-FEATURE` when not present. No kernel registration needed.

## Conventions

- **Ownership split.** This skill owns *what* goes in the stack and
  *why*. `python-env-manager` owns *how* it is installed (manager
  detection, command syntax, feature/layout). Never put install
  command tables here; link to `python-env-manager` instead.
- **Versions:** don't pin unless the user asks or there's a known
  incompatibility. **Exception — `skore` and `skrub` must always be
  the latest available release.**
- **One tool per job:** don't introduce a second library for a task
  already covered without explicit user request. (One library *can*
  own multiple jobs — `skore` covers both evaluation and tracking.
  The rule forbids piling a second tool onto a covered job, not a
  single tool covering multiple jobs.)
- **Line width:** wrap text at 88 chars where natural. Don't compress
  content to fit; long inline links and code spans are fine to leave
  on longer lines.
