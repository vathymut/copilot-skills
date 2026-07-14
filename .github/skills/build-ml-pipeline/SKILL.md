---
name: build-ml-pipeline
description: "Declare ML pipelines as skrub DataOps graphs, stopping at the predictor object."
---

# Build ML Pipeline (Declaration)

Declarative shape of a Python ML pipeline from data source to
predictor.

## Next-step pointers

| After this skill… | → next |
|---|---|
| CV strategy | `evaluate-ml-pipeline` § Evaluate |
| Smoke test | `evaluate-ml-pipeline` § Smoke |
| Symbol lookup | `python-api` |
| Missing import | `python-env-manager` |
| Code just edited | `python-quality` |

Key terms (`X marker`, `predict grid`, `cross-row step`, `Layers 1/2/3`)
are introduced inline in Rule 2.

## Canonical pipeline shape — IID flat-table

The 90% case. Copy + adapt; replace `TARGET_COL` and the regressor.

```python
import skrub
from sklearn.ensemble import HistGradientBoostingRegressor

from <pkg>.data import TARGET_COL, load_raw


def build_learner(data_dir_preview=None):
    """Return the unfit learner (skrub SkrubLearner)."""
    data_dir = (
        skrub.var("data_dir", value=str(data_dir_preview))
        if data_dir_preview is not None
        else skrub.var("data_dir")
    )

    # Layer 1 + 2: load + mark X / y on the source frame.
    # No cross-row feature steps → marker sits here.
    data = data_dir.skb.apply_func(load_raw)
    X = data.drop(columns=[TARGET_COL]).skb.mark_as_X()
    y = data[TARGET_COL].skb.mark_as_y()

    # Layer 3: estimator at the tail. Feature engineering (if any)
    # chains between mark_as_X and the final .skb.apply.
    predictions = X.skb.apply(
        HistGradientBoostingRegressor(random_state=0), y=y
    )
    return predictions.skb.make_learner()
```

For history-dependent / panel / cold-start cases (≠ IID):
→ `references/layer_examples.md` § history-dependent.

For loader-baked-shift counter-example (what NOT to do):
→ `references/layer_examples.md` § counter-example.

## Stop conditions

- **Missing dependency.** `import skrub` raising → `python-env-manager`.
  Do not substitute `sklearn.Pipeline` / `make_pipeline` /
  `FunctionTransformer`.
- **Symbol from memory is forbidden.** Use `python-api` this turn.
- **Splitter imports are out of scope.** Only `split_kwargs` at the
  X marker.
- **Python-stack defaults apply.** See `python-api` / `python-quality`.

## Core rules

### Rule 1 — Skrub DataOps is the entry point

Declare the pipeline as a `skrub.var(...)` graph rooted on source
identifiers. `skrub.X(...)` / `skrub.y(...)` shortcut roots and
materialized DataFrame roots are forbidden. Source binding details:
`references/source-binding.md`.

### Rule 2 — Mark the X early; featurize after

The **X marker** (`.skb.mark_as_X()`) is the shared-vs-predict-specific
boundary. The **predict grid** is the rows you want predictions for:
- IID: the loaded frame itself.
- Panel / time-series: a `(group, time)` set.

Ask: *does any feature step look at rows other than the one currently
being processed?*

| Answer | Marker placement |
|---|---|
| No (per-row math, stateful encoders that learn once and apply per-row) | On the loaded source frame |
| Yes (lag, rolling, cross-row join, target shift) | Upstream of every cross-row step |

**Layers 1 / 2 / 3:**

1. **Sources.** One `skrub.var(...)` per input identifier. Loaders are
   pure functions of that identifier. No task-specific filters here.
2. **Predict grid + X marker.** Rows = predict grid. `mark_as_X` /
   `mark_as_y` go here. Target derivation requiring history belongs to
   a stateful `BaseEstimator`.
3. **Features after the marker.** History-dependent steps take the X
   DataOp *and* relevant Layer-1 source DataOp(s) as extra arguments.

Worked examples (IID, history-dependent, counter-example):
`references/layer_examples.md`. Production-style alignment walkthrough:
`python-api/references/pre_mark_alignment.md`.

A **cold-start row** has no in-slice history available. A late marker
silently drops them at predict time. The smoke test in
`evaluate-ml-pipeline` § Smoke proves correct placement by construction.

**Preview value** is an optional kwarg from the caller, never a
relative-path literal in `pipeline.py`.

**Cross-validation metadata** at the marker: if group or temporal
structure exists, wire it in `split_kwargs={...}`. Do not use `cv=` here.

### Rule 3 — Stateless → function; stateful → estimator

- **Stateless:** output depends only on the current row and constants.
  → `.skb.apply_func(pure_fn)`.
- **Stateful:** learns from training data and reapplies to test.
  → `.skb.apply(sklearn_estimator)`.

The litmus test: *would output change if run on the training subset
alone?* If yes, it is stateful.

## Common patterns

Short catalogue; look up exact symbols in `python-api`. Full code:
`references/common_patterns.md`.

1. Heterogeneous columns — skrub column selectors, not `ColumnTransformer`.
2. Default starting point — `skrub.tabular_pipeline(...)` or
   `TableVectorizer` + estimator.
3. Multi-table inputs — one `skrub.var(...)` per table; join with
   `Joiner` / `AggJoiner` / `MultiAggJoiner`.
4. Meta-estimator tail — `StackingClassifier`,
   `CalibratedClassifierCV`, `TransformedTargetRegressor`.
5. Hyperparameter knobs — `skrub.choose_from` / `choose_int` /
   `choose_float` / `optional`.
6. Custom transformer — subclass `BaseEstimator` + `TransformerMixin`
   only when stateful and no built-in fits.

## Pre-flight

```
Pre-flight (build-ml-pipeline):
- [ ] Tier 1 libs importable: sklearn, skrub, skore
- [ ] Tabular library identified: pandas | polars
- [ ] python-api consulted for skrub/sklearn symbols this turn
- [ ] Source-binding pattern chosen (list each skrub.var)
- [ ] X-marker placement decided (name the DataOp node)
- [ ] (Cross-row only) Each cross-row step refs upstream history DataOp
- [ ] Layer 1 audit passes constructive test (Rule 2)
- [ ] Preview value as kwarg, not literal in pipeline.py
- [ ] split_kwargs at X marker decided: groups | time | none
- [ ] Smoke test wired (tests/smoke/test_NN_<short_name>.py)
- [ ] Pre-flight re-emitted with evidence before final message.
```

## Core rules

### Rule 1 — Skrub DataOps is the entry point

Declare the pipeline as a `skrub.var(...)` graph rooted on source
identifiers. `skrub.X(...)` / `skrub.y(...)` shortcut roots and
materialized DataFrame roots are forbidden. Source binding details:
`references/source-binding.md`.

### Rule 2 — Mark the X early; featurize after

The **X marker** (`.skb.mark_as_X()`) is the shared-vs-predict-specific
boundary. The **predict grid** is the rows you want predictions for:
- IID: the loaded frame itself.
- Panel / time-series: a `(group, time)` set.

Ask: *does any feature step look at rows other than the one currently
being processed?*

| Answer | Marker placement |
|---|---|
| No (per-row math, stateful encoders that learn once and apply per-row) | On the loaded source frame |
| Yes (lag, rolling, cross-row join, target shift) | Upstream of every cross-row step |

**Layers 1 / 2 / 3:**

1. **Sources.** One `skrub.var(...)` per input identifier. Loaders are
   pure functions of that identifier. No task-specific filters here.
2. **Predict grid + X marker.** Rows = predict grid. `mark_as_X` /
   `mark_as_y` go here. Target derivation requiring history belongs to
   a stateful `BaseEstimator`.
3. **Features after the marker.** History-dependent steps take the X
   DataOp *and* relevant Layer-1 source DataOp(s) as extra arguments.

Worked examples (IID, history-dependent, counter-example):
`references/layer_examples.md`. Production-style alignment walkthrough:
`python-api/references/pre_mark_alignment.md`.

A **cold-start row** has no in-slice history available. A late marker
silently drops them at predict time. `evaluate-ml-pipeline` § Smoke
proves correct placement by construction.

Preview value is an optional caller kwarg, never a relative-path literal.

### Rule 3 — Stateless → function; stateful → estimator

- **Stateless:** output depends only on the current row and constants.
  → `.skb.apply_func(pure_fn)`.
- **Stateful:** learns from training data and reapplies to test.
  → `.skb.apply(sklearn_estimator)`.

**Leakage rule:** any computation using full-data statistics (means,
quantiles, vocabularies, target distribution) must be stateful.

## Common patterns

Look up exact symbols in `python-api`. Full catalogue:
`references/common_patterns.md`.

1. Heterogeneous columns — skrub column selectors, not `ColumnTransformer`.
2. Default starting point — `skrub.tabular_pipeline(...)` or
   `TableVectorizer` + estimator.
3. Multi-table inputs — one `skrub.var(...)` per table; join with
   `Joiner` / `AggJoiner` / `MultiAggJoiner`.
4. Meta-estimator tail — `StackingClassifier`,
   `CalibratedClassifierCV`, `TransformedTargetRegressor`.
5. Hyperparameter knobs — `skrub.choose_from` / `choose_int` /
   `choose_float` / `optional`.
6. Custom transformer — subclass `BaseEstimator` + `TransformerMixin`
   only when stateful and no built-in fits.

## References

- `writing-great-skills:references/ml-companion-skills.md` — ownership
  map.
- `writing-great-skills:references/ml-gates.md` — gate registry.
- `references/source-binding.md` — root-binding patterns.
- `references/layer_examples.md` — IID, history-dependent, counter-example.
- `references/reproducibility.md` — persistence / reproducibility checks.
- `references/common_patterns.md` — recurring pipeline shapes.
