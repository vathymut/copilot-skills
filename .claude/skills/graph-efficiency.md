# Graph Tool Efficiency

Token rules for the code-review-graph MCP tools. Referenced by `refactor-safely` and `review-changes`.

- **Always start with `get_minimal_context(task="<your task>")`** before any other graph tool — it returns graph stats, risk score, and suggested next tools in ~100 tokens.
- **`detail_level="minimal"` on all calls.** Escalate to "standard" only when minimal is insufficient to answer.
- **Budget: ≤5 graph calls per task.** Count your calls; past 4 with the question still open, stop exploring and answer from what you have — or ask the user.
- **Prefer one purpose-built tool over several generic ones** — e.g. `detect_changes_tool` over a manual `git diff` plus `query_graph_tool` sequence.
