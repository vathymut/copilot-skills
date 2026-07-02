# Common Patterns — full catalogue

Look up exact symbols in `python-api`. Short index in `SKILL.md`;
full catalogue with code here.

## 1. Heterogeneous columns

skrub column selectors with `cols=` on `.skb.apply` (one apply
per group), not `ColumnTransformer`.

## 2. Default starting point for tabular data

Reach for `skrub.tabular_pipeline(...)` or `TableVectorizer` +
estimator first; specialize column-by-column only when default is
insufficient.

## 3. Multi-table inputs

One `skrub.var(...)` per table; join with skrub `Joiner` /
`AggJoiner` / `MultiAggJoiner` via `.skb.apply(...)`.

## 4. Meta-estimator at the tail

`StackingClassifier`, `CalibratedClassifierCV`,
`TransformedTargetRegressor`. Wrap the predictor first, then
attach via `.skb.apply` as the final step.

## 5. Mark hyperparameter knobs in place

Wrap with `skrub.choose_from` / `choose_int` / `choose_float` /
`optional` inside the declaration. Don't import `GridSearchCV`
here; the tuning skill owns search.

## 6. Custom sklearn transformer

Author only when (a) no built-in fits and (b) the operation is
stateful. Subclass `BaseEstimator` + `TransformerMixin`. For a
stateless op, write a function and use `.skb.apply_func`.
