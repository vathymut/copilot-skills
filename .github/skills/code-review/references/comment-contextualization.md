# Contextualize the comments

ruff makes a file *well-formed*; this pass makes it *well-documented
for the problem*. Templates ship with neutral placeholders and a
little authoring scaffolding so the generating skill knows what each
cell / module is for. None of that should survive into the user's
committed file — the user's files document the **problem being
solved**, not the process that produced them.

After the ruff trio (see `references/python-standards.md` §
"Post-edit run ('the ruff trio')"), for every touched file that now
carries **real content**, do a quick documentation pass:

1. **Fill the header for this problem.** Replace any `<placeholder>`
   or generic header with a one- or two-line description of what this
   file does *here*, written for the project this file belongs to.
   Pick the framing that fits the file's role: the experiment /
   script's purpose (`experiments/<name>.py`), what this module
   contributes to the codebase (`src/<pkg>/*.py`), which report /
   review this file produces and what it covers
   (`audit/<stem>.py`), or what the dataset is and what the analysis
   looks at (`data/<name>.py`). Pull the wording from the live
   context — the project goal, the approved design note, the
   dataset, the spec.
2. **Strip the workflow meta.** Delete leftover process commentary:
   skill names, gate IDs (`G-*`), `§` cross-references, "the agent",
   "the (cell) runner", "the digest", "run cell by cell", journal /
   backlog / sourcing jargon, and inline guard-rails like "MUST NOT
   call `put` / bare expressions, don't `print`". Those guard-rails
   stay enforced — they live in the owning skill's SKILL.md, which is
   where the agent reads them, not in the user's file.
3. **Keep the substance.** Genuinely useful problem / engineering
   context and the numpydoc docstrings stay. Cell markers (`# %%`)
   and any remaining `<...>` placeholders the agent still has to fill
   stay until they are filled.

The result should read like a colleague wrote the file for this
project — not like a generated scaffold. Skip a file that is still an
empty skeleton (e.g. a freshly scaffolded `src/<pkg>/*.py` with no
body yet): there is no context to write about until the content
lands, and the contextualization happens on the edit that fills it.

This pass is **owned here** so the rule is enforced uniformly. Every
file-writing skill already hands off to this skill after a write;
that hand-off now also covers contextualizing the comments.
