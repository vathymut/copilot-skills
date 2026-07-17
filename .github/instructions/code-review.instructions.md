---
applyTo: "**/*.md"
description: "Code-review standards for skills and agents"
---

# Code-review standards

Apply the repository-wide guidance from `../copilot-instructions.md` to all catalog edits.

## General guidelines

- Verify `SKILL.md` frontmatter contains only `name` and `description`, and that the `description` reads as a clear trigger.
- Verify `.agent.md` files have `description`, `tools`, and `model` frontmatter.
- Confirm new or removed skills/agents are reflected in `README.md` and `docs/catalog.md` counts.
- Check that attribution comments are present where content was adapted from upstream (e.g. awesome-copilot).
- Ensure instructions files contain guidance only — no code snippets — and valid `applyTo` globs.
- Reject any change that symlinks `.github/agents/` into OpenCode.
