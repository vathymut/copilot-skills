---
name: visualization
description: User-invoked router for chart, diagram, and figure skills. Type this skill name to see which visualization skill to use.
disable-model-invocation: true
---

# Visualization Router

Index of chart, diagram, and figure skills. Invoke the right skill by name; high-frequency skills also auto-trigger.

| Skill | Use when |
|---|---|
| `tufte-data-viz` | Create or review any chart, graph, dashboard, or data visualization. |
| `mermaid-diagram-specialist` | Create a flowchart, sequence diagram, ERD, class diagram, state diagram, Gantt, or C4 diagram in Mermaid. |
| `academic-plotting` | Generate publication-quality figures for an ML/AI paper. |

Default routing: for open-ended chart/visualization requests, invoke
`tufte-data-viz` unless the use case clearly points to one of the others
(e.g., a paper figure → `academic-plotting`, a Mermaid diagram in docs →
`mermaid-diagram-specialist`).
