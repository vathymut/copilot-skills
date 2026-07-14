"""Smoke test for `experiments/NN_<short_name>.py`."""

import pytest

from <pkg> import PROJECT_ROOT
from <pkg>.pipeline import build_learner

# Hardcoded from journal/NN_<short_name>.md Status.headline after the run.
CV_MAE_MEAN = 0.0

DATA_DIR = PROJECT_ROOT / "data"


@pytest.fixture
def train_predict_envs(tmp_path):
    """Build (train_env, predict_env, n_predict_grid_rows, y_true).

    Diagnostic by construction: predict_env carries only the rows we
    want predictions for, with no pre-history padding.
    """
    # ... fixture construction ...
    return train_env, predict_env, n_predict_grid_rows, y_true


def test_NN_<short_name>(train_predict_envs):
    """Predict-time replay yields one prediction per predict-grid row."""
    train_env, predict_env, n_predict_grid_rows, y_true = train_predict_envs

    learner = build_learner()
    learner.fit(train_env)
    predictions = learner.predict(predict_env)

    assert len(predictions) == n_predict_grid_rows, (
        f"got {len(predictions)} predictions for {n_predict_grid_rows} "
        "predict-grid rows — pipeline is dropping cold-start rows; check "
        "mark_as_X placement and history-dependent feature wiring."
    )

    from sklearn.metrics import mean_absolute_error

    smoke_mae = mean_absolute_error(y_true, predictions)
    assert smoke_mae < 3 * CV_MAE_MEAN, (
        f"smoke MAE {smoke_mae:.0f} > 3 × CV mean ({CV_MAE_MEAN:.0f}); "
        "predictions may be NaN-poisoned."
    )
