---
name: build-ml-pipeline
description: Use when declaring an ML pipeline with skrub and the source-to-X-marker-to-estimator shape is needed, or when an import, dependency, or symbol is uncertain.
---

# Build ML Pipeline (Declaration)

Declarative shape of a Python ML pipeline from data source to predictor.
Key terms (`X marker`, `predict grid`, `cross-row step`, `Layers 1/2/3`): see `references/layer_examples.md` § terminology.

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

```
Pre-flight (build-ml-pipeline):
- [ ] Tier 1 libs importable: sklearn, skrub, skore
- [ ] Tabular library identified: pandas | polars
- [ ] python-api consulted for skrub/sklearn symbols this turn
- [ ] Source-binding pattern chosen (list each skrub.var)
- [ ] X-marker placement decided (name the DataOp node)
- [ ] (Cross-row only) Each cross-row step refs upstream history DataOp
- [ ] Preview value as kwarg, not literal in pipeline.py
- [ ] split_kwargs at X marker decided: groups | time | none
- [ ] Smoke test wired (tests/smoke/test_NN_<short_name>.py)
- [ ] Pre-flight re-emitted with evidence before final message.
```

## Stop conditions

- **Missing dependency.** `import skrub` fails → `python-env-manager`. No substitute.
- **Symbol from memory is forbidden.** Use `python-api` this turn.
- **Splitter imports are out of scope.** Only `split_kwargs` at the X marker.
- **Python-stack defaults apply** — ruff, `scratch/` rule, harness hints: `ml-conventions:references/shared-ml-conventions.md`.

## Common patterns

1. Heterogeneous columns — skrub selectors, not `ColumnTransformer`.
2. Default — `skrub.tabular_pipeline(...)` or `TableVectorizer` + estimator.
3. Multi-table — one `skrub.var(...)` per table; `Joiner` / `AggJoiner` / `MultiAggJoiner`.
4. Meta-estimator tail — `StackingClassifier`, `CalibratedClassifierCV`, `TransformedTargetRegressor`.
5. Hyperparameters — `skrub.choose_from` / `choose_int` / `choose_float` / `optional`.
6. Custom transformer — `BaseEstimator` + `TransformerMixin` only when stateful.

Full code: `references/common_patterns.md`.

## References

- `iterate-ml-experiment` — ownership map.
- `ml-conventions:references/ml-gates.md` — gate registry.
- `references/source-binding.md` — root-binding patterns.
- `references/layer_examples.md` — IID, history-dependent, counter-example, terminology.
- `references/reproducibility.md` — persistence / reproducibility checks.
- `references/common_patterns.md` — recurring pipeline shapes.
