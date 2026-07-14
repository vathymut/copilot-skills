# Numpydoc — the docstring convention

Public functions and classes carry numpydoc-format docstrings; ruff's
`D` rules with `pydocstyle.convention = "numpy"` enforce the shape.

**A bare one-line summary is NOT sufficient for public functions.**
The `Parameters` / `Returns` (and `Raises` when applicable) sections
are mandatory — even when the function is small, even when the user
says "just the summary is fine". Approving a one-line docstring on
a public function silently fails the contract this skill enforces;
the function looks `D`-rule-clean (D100/D103 don't fire) but the
parameter shapes and return type that callers actually need are
missing. Private helpers (`_leading_underscore`) are the only
exception: the default `D` rules allow them to omit docstrings, but
public callable surfaces always carry the full numpydoc shape.

Skeleton:

```python
def predict_price(X, model, *, n_jobs=1):
    """Predict option prices from a feature matrix.

    Parameters
    ----------
    X : pandas.DataFrame
        Feature matrix with one row per option.
    model : sklearn.base.BaseEstimator
        Fitted estimator with a ``predict`` method.
    n_jobs : int, default=1
        Number of parallel jobs.

    Returns
    -------
    numpy.ndarray of shape (n_samples,)
        Predicted prices, one per row of ``X``.
    """
```

Conventions worth surfacing because they're non-obvious:

- **One-line summary on the first line**, in the imperative mood
  ("Predict ..." not "Predicts ..."). No trailing period in the
  summary line if D400 is enabled — but in `numpy` convention it
  is, so write the period.
- **Blank line between summary and the rest.**
- **Parameter shapes go in the type slot**, not the description, e.g.
  `X : ndarray of shape (n_samples, n_features)`.
- **`Returns` section** lists the return value; if there are
  multiple returns, list each on its own row. Don't omit the type.
- **Private helpers** (`_leading_underscore`) don't need a docstring
  under the default `D` rules — ruff allows that.
- **Modules** (top of file) should start with a one-line summary.
  Skipped under `experiments/**` per the bundled `ruff.toml`.
