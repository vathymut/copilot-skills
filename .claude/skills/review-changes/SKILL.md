---
name: review-changes
---

# Review Changes

Perform a thorough, risk-aware code review using the knowledge graph.

Token budget and `get_minimal_context` rules: see `graph-efficiency.md` in this directory.

### Steps

1. Run `detect_changes_tool` to get risk-scored change analysis.
2. Run `get_affected_flows_tool` to find impacted execution paths.
3. For each high-risk function, run `query_graph_tool` with pattern="tests_for" to check test coverage.
4. Run `get_impact_radius_tool` to understand the blast radius.
5. For any untested changes, suggest specific test cases.

### Output Format

Provide findings grouped by risk level (high/medium/low) with:

- What changed and why it matters
- Test coverage status
- Suggested improvements
- Overall merge recommendation
