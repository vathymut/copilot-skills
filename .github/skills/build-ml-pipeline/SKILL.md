---
name: build-ml-pipeline
description: Use when declaring an ML pipeline with skrub and the source-to-X-marker-to-estimator shape is needed.
---

# Build ML Pipeline (Declaration)

Declarative shape of a Python ML pipeline from data source to predictor.
Key terms (`X marker`, `predict grid`, `cross-row step`, `Layers 1/2/3`): see `references/layer_examples.md` § terminology.

## When NOT to use

- Single-table IID data without joins or cross-row features — plain `sklearn.Pipeline` or `sklearn.compose.ColumnTransformer` is simpler; this skill adds skrub overhead.
- You need to run cross-validation right now — use `evaluate-ml-pipeline` after declaring.
- No `skrub`/`sklearn` stack — route to `python-stack-env` first.


## Gates (one-line)

| Gate | Owner | Meaning |
|---|---|---|
| G-PKG-NAME | `iterate-ml-experiment` §0.5 | Python package name |
| G-ENV-MGR | `python-stack-env` | Env manager (pixi/uv/poetry/…) |
| G-TABULAR | `iterate-ml-experiment` §0.5 | `pandas` vs `polars` |
| G-SKORE-MODE | `iterate-ml-experiment` §0.5 | `local`/`hub`/`mlflow` |
| G-EDA | `ml-eda` / `iterate-ml-experiment` §0 | `run`/`skip` |
| G-DESIGN | `iterate-ml-experiment` §3 | Design note approved? |
| G-CV-SPLITTER | `evaluate-ml-pipeline` §Evaluate | Splitter derived from `split_kwargs` |
| G-RUN | `iterate-ml-experiment` §3 | Run now vs leave for later |

Full wording: `ml-conventions:references/ml-gates.md`. Harness hints never waive `AskUserQuestion` gates.

## Decision flow

**1 — Pick source binding pattern.** Root the pipeline on `skrub.var(...)` identifiers. `skrub.X(...)` / `skrub.y(...)` shortcut roots and materialized DataFrame roots are forbidden. See `references/source-binding.md`.

**2 — Place the X marker.** The X marker (`.skb.mark_as_X()`) is the shared-vs-predict-specific boundary. Ask: *does any feature step look at rows other than the one currently being processed?*

| Answer | Marker placement |
|---|---|
| No (per-row math, stateful encoders that learn once and apply per-row) | On the loaded source frame |
| Yes (lag, rolling, cross-row join, target shift) | Upstream of every cross-row step |

Wire `split_kwargs={...}` at the marker for group/temporal structure. No `cv=` here.

**3 — Stateless vs stateful.** Litmus test: *Would output change if run on the training subset alone?* Yes → `.skb.apply(sklearn_estimator)` (stateful). No → `.skb.apply_func(pure_fn)` (stateless).

## Canonical shape — IID flat-table (90% case)

```python
import skrub
from sklearn.ensemble import HistGradientBoostingRegressor
from <pkg>.data import TARGET_COL, load_raw

def build_learner(data_dir_preview=None):
    data_dir = skrub.var("data_dir", value=str(data_dir_preview)) if data_dir_preview is not None else skrub.var("data_dir")
    data = data_dir.skb.apply_func(load_raw)
    X = data.drop(columns=[TARGET_COL]).skb.mark_as_X()
    y = data[TARGET_COL].skb.mark_as_y()
    predictions = X.skb.apply(HistGradientBoostingRegressor(random_state=0), y=y)
    return predictions.skb.make_learner()
```

For history-dependent / panel / cold-start cases → `references/layer_examples.md`. Counter-example: same ref.

## Pre-flight

Shared gates → `ml-conventions:references/shared-preflight-evidence.md` (don't duplicate that contract here).

```
Pre-flight (build-ml-pipeline):
- [ ] Tabular library identified: pandas | polars
- [ ] Source-binding pattern chosen (list each skrub.var)
- [ ] X-marker placement decided (name the DataOp node)
- [ ] (Cross-row only) Each cross-row step refs upstream history DataOp
- [ ] Preview value as kwarg, not literal in pipeline.py
- [ ] split_kwargs at X marker decided: groups | time | none
- [ ] Smoke test wired (tests/smoke/test_NN_<short_name>.py)
- [ ] Plus shared gates from ml-conventions; re-emit with evidence before final message.
```

## Stop conditions

- **Missing dependency.** `import skrub` fails → `python-stack-env`. No substitute.
- **Symbol from memory is forbidden.** Use `python-api` this turn.
- **Splitter imports are out of scope.** Only `split_kwargs` at the X marker.
- **Python-stack defaults apply** — ruff, `scratch/` rule, harness hints: `ml-conventions:references/shared-ml-conventions.md`.
- **Ownership map:** `iterate-ml-experiment`.

## Common patterns

1. Heterogeneous columns — skrub selectors, not `ColumnTransformer`.
2. Default — `skrub.tabular_pipeline(...)` or `TableVectorizer` + estimator.
3. Multi-table — one `skrub.var(...)` per table; `Joiner` / `AggJoiner` / `MultiAggJoiner`.
4. Meta-estimator tail — `StackingClassifier`, `CalibratedClassifierCV`, `TransformedTargetRegressor`.
5. Hyperparameters — `skrub.choose_from` / `choose_int` / `choose_float` / `optional`.
6. Custom transformer — `BaseEstimator` + `TransformerMixin` only when stateful.

Full code: `references/common_patterns.md`. Persistence / reproducibility checks: `references/reproducibility.md`.

## Completion criteria

- [ ] `skrub.var` source binding chosen; X marker placed per decision flow with `split_kwargs`
- [ ] Stateless (`apply_func`) vs stateful (`apply`) correct per litmus test
- [ ] `build_learner(data_dir_preview=None)` returns `skb.make_learner()`; no shortcut roots
- [ ] Pre-flight emitted with evidence; symbols verified via `python-api`

## Related skills

- `evaluate-ml-pipeline` — next: CV + smoke after declaration.
- `iterate-ml-experiment` — orchestrates this + evaluate + smoke.
- `python-stack-env` — missing `skrub`/`sklearn`.
- `ml-eda` — run before first pipeline.
