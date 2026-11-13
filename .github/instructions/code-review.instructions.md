---
applyTo: "**/*.md"
description: "Code-review standards for catalog edits"
---

# Code-review standards

Apply the repository-wide guidance from `../copilot-instructions.md` to all catalog edits.

## General guidelines

- Verify `SKILL.md` frontmatter contains only `name` and `description`, and that the `description` reads as a clear trigger.
- Confirm new or removed skills are reflected in `README.md` and `docs/catalog.md` counts.
- Check that attribution comments are present where content was adapted from upstream (e.g. awesome-copilot).
- Ensure instructions files contain guidance only — no code snippets — and valid `applyTo` globs.
