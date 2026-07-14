# %% [markdown]
# # EDA for `<pkg>`
#
# One project-level exploration. Reads `<LOAD_RAW_DATA>` and produces
# durable deliverables under `<project>/data/`.

# %%
from pathlib import Path

import skrub

from <pkg> import PROJECT_ROOT

# The raw source may live anywhere; only the deliverables are pinned to data/.
RAW = <LOAD_RAW_DATA>
TARGET = "<TARGET_COLUMN>"

# %%
RAW.shape

# %% [markdown]
# ## Table overview

# %%
table_report = skrub.TableReport(RAW, title="<table> overview", verbose=0)
EDA_DIR = PROJECT_ROOT / "data"
EDA_DIR.mkdir(parents=True, exist_ok=True)
table_report.write_html(EDA_DIR / "eda_<table>.html")
table_report.json()

# %% [markdown]
# ## Column associations

# %%
skrub.column_associations(RAW)

# %% [markdown]
# ## Target summary

# %%
RAW[TARGET].describe() if TARGET != "n/a" else "no single target column"
