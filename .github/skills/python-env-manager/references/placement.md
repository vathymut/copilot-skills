# Package placement — 3-feature layout (extracted)

Load when routing a dependency.


### The fixed buckets

| Bucket | Contents | Composes with | Purpose |
|---|---|---|---|
| `default` | `scikit-learn`, `skrub`, `skore`, tabular lib, editable `<pkg>` | (itself) | runtime |
| `dev` | `ruff`, `pytest`, `jupyterlab`, `ipykernel` | `default + dev` | lint / test / interactive notebooks |
| `agent` | `ipython`, `pyright` | `default + agent` | audit runner + pyright CLI |
| `lsp` | (no own deps) | `default + dev + agent + <all optional>` | LSP integration |

Pixi composed-envs declaration in `references/composition_model.md`.

### Auto-routing table — no ask

| Package | Routes to |
|---|---|
| `scikit-learn`, `skrub`, `skore` (or `skore[hub]`) | `default` |
| `pandas` + `pyarrow` OR `polars` | `default` |
| `ruff`, `pytest`, `jupyterlab`, `ipykernel` | `dev` |
| `ipython`, `pyright` | `agent` |
| The editable workspace package (`<pkg> @ .`) | `default` |

Ambiguous → `G-ENV-SCOPE` fires.

## Install commands — by manager
