---
applyTo: "**"
description: "Security best practices for samesame"
---

# Security Best Practices

Apply the repository-wide guidance from `../copilot-instructions.md` to all code.

## Supply Chain Security

- Pin all development dependencies in `pyproject.toml` with version bounds; avoid `latest` or `*` specifiers in production dependencies.
- Never commit secrets, API keys, or credentials to the repository.
- Use `uv lock` and commit `uv.lock` so CI builds are reproducible.

## Input Validation

- Validate all inputs at public API boundaries before any numerical computation.
- Check array shapes, dtypes, and value ranges (e.g., reject non-finite values, enforce binary `{0, 1}` for treatment arrays).
- Raise `ValueError` or `TypeError` with descriptive messages; never silently coerce invalid inputs.
- Use `sklearn.utils.validation.check_array` or equivalent where applicable.

## Serialisation and File I/O

- Do not use `pickle` for untrusted input; prefer `numpy.save`/`numpy.load` with `allow_pickle=False` if serialisation is needed.
- If loading files from paths supplied by callers, validate that the resolved path stays within an expected directory.

## Dependency Security

- Run `uv audit` (or equivalent) in CI to catch known CVEs in transitive dependencies.
- Avoid importing optional heavy dependencies at module level; use lazy imports with a clear `ImportError` message so the library remains usable without them.

## Statistical Security Considerations

- Do not expose internal model state or intermediate scores that could be used to reconstruct training data.
- When seeding random number generators, document that reproducibility does not imply security-grade randomness.
