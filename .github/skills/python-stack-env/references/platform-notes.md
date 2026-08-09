# Platform-specific notes

## skrub install — macOS post-install

When skrub is being installed (or has just been installed) **and**
the platform is macOS, run `dot -c` in the project's env once the
install lands. This rebuilds graphviz's plugin / format cache;
skipping it leaves the first `.skb.draw_graph()` /
`.skb.full_report()` call printing format warnings or erroring out
on font lookup.

```bash
# right after the skrub install command lands, on macOS only:
[[ "$(uname)" == "Darwin" ]] && pixi run dot -c
```

Per manager, swap the env-run prefix: `pixi run` / `uv run` /
`poetry run` / `hatch run` / `conda run -n <env>` / activated
`venv` → bare `dot -c`. Linux + Windows: no-op, skip the call.
One-shot — no need to re-run on subsequent sessions unless graphviz
itself was reinstalled.
