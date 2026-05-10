---
applyTo: "src/**/*.py, docs/**/*.md"
description: "Documentation standards for samesame"
---

# Documentation Standards

Apply the repository-wide guidance from `../copilot-instructions.md` to all documentation.

## Docstring Format

- Every public function, class, and module requires a NumPy-style docstring.
- Required sections: `Parameters`, `Returns`, `Examples`. Optional sections: `Notes`, `References`, `See Also`, `Raises`.
- The `Examples` section must contain at least one runnable doctest that passes without side effects.
- `numpydoc_validation` is enforced in CI — match parameter names and types exactly between signature and docstring.

## API Reference

- API reference pages live in `docs/api/` and are built automatically from docstrings via `mkdocstrings-python`.
- New public modules require a corresponding `docs/api/<module>.md` page mirroring the structure of existing pages (e.g., `docs/api/testing.md`).
- Experimental modules must display a note admonition at the top of their API page: _"Experimental: API may change before the v2.0 stability guarantee."_

## Tutorials and Examples

- Tutorials live in `docs/examples/tutorials/` and should be self-contained Markdown documents with code blocks.
- Use only generic, cliché placeholder data in examples (e.g., `rng.normal(size=600)`); never use real or domain-specific data.
- Follow the domain language in `CONTEXT.md`; do not use terms listed under _Avoid_.

## Prose Documentation

- Write in clear, concise English; target an audience of ML practitioners and data scientists.
- Prefer active voice and short sentences.
- Cross-reference related functions with Markdown links (e.g., `[test_shift][samesame.test_shift]`).
- Update `mkdocs.yml` nav when adding or renaming pages.
