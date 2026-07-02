# Install commands — by manager

Once detected, use ONLY the matching commands. Per-manager extended
prose (the "why" + caveats per row) lives in
`references/install_commands_anatomy.md`.

## pixi

| Action | Command |
|---|---|
| Add to default | `pixi add <pkg>` |
| Add to a feature | `pixi add --feature <feature> <pkg>` |
| Add to an env | `pixi add -e <env> <pkg>` |
| Remove | `pixi remove <pkg>` (or `--feature <feature>`) |
| Upgrade | `pixi upgrade <pkg>` |
| Run inside env | `pixi run -e <env> <command>` |
| Sync from manifest | `pixi install` |

## uv

`default` → `[project] dependencies`; `dev` → `--group dev`;
`agent` → `--group agent`; optional features → `--group <name>`.

| Action | Command |
|---|---|
| Add runtime | `uv add <pkg>` |
| Add dev | `uv add --dev <pkg>` |
| Add to group | `uv add --optional <group> <pkg>` |
| Remove | `uv remove <pkg>` |
| Upgrade | `uv lock --upgrade-package <pkg>` |
| Run inside env | `uv run <command>` |
| Sync | `uv sync` (use `--all-groups` to cover dev+agent+optional) |

## poetry

`default` → `[tool.poetry.dependencies]`; `dev` → `--group dev`;
`agent` → `--group agent`; optional → `--group <name>`.

| Action | Command |
|---|---|
| Add runtime | `poetry add <pkg>` |
| Add dev | `poetry add --group dev <pkg>` |
| Add to group | `poetry add --group <name> <pkg>` |
| Remove | `poetry remove <pkg>` |
| Upgrade | `poetry update <pkg>` |
| Run | `poetry run <command>` |
| Sync | `poetry install` |

## hatch

Declarative — no universal `hatch add`. Edit
`pyproject.toml`:`[project] dependencies` or
`[tool.hatch.envs.<env>.dependencies]`, then any
`hatch run -e <env> <command>` re-creates the env. Caveat: hatch
envs do not compose; each non-default env duplicates runtime deps.

## conda / mamba

No native feature concept; map buckets to named envs
(`<project>`, `<project>-dev`, `<project>-agent`).

| Action | Command |
|---|---|
| Add (conda-forge) | `conda install -n <env> -c conda-forge <pkg>` |
| With mamba | `mamba install -n <env> -c conda-forge <pkg>` |
| Remove | `conda remove -n <env> <pkg>` |
| Sync from yml | `conda env update -f environment.yml --prune` |

## pip + venv

Least-integrated. No manifest update — `pip install` mutates the
live env without tracking. Recommend migration to a managed
alternative.

Editable workspace install (`src/<pkg>/`) per manager:
→ `references/editable_workspace.md`.
