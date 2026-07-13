---
name: mermaid-diagram-specialist
description: >-
  Mermaid diagram specialist for creating flowcharts, sequence diagrams, ERDs,
  and architecture visualizations. Use when creating technical documentation,
  visualizing workflows, documenting architecture, or explaining system design.
disable-model-invocation: true
---

# Mermaid Diagram Specialist

## Step 1: Understand the requirement

Clarify what needs visualizing — the entities, relationships, interactions, or states involved. Ask for specs, code, or examples if the description is vague.

**Completion criterion:** You can name the diagram type, the audience, and the key elements to include.

## Step 2: Select diagram type

| Need | Diagram |
|------|---------|
| Process with decisions | Flowchart |
| API/system interactions | Sequence Diagram |
| Database structure | ERD |
| System architecture | C4 Diagram |
| Object relationships | Class Diagram |
| State transitions | State Diagram |
| Project timeline | Gantt Chart |

Consult [`references/syntax.md`](references/syntax.md) for the selected type's syntax and examples.

**Completion criterion:** Diagram type chosen, syntax reference loaded.

## Step 3: Draft the mermaid syntax

Write the diagram code following these principles:

- **Simplicity**: focused, uncluttered, under 20 nodes for readability
- **Labels**: clear, descriptive, concise
- **Direction**: consistent flow (top-down or left-right)
- **Grouping**: subgraphs for related elements
- **Notes**: annotate complex logic

Use `subgraphs` to cluster related nodes. Keep diagram source in markdown files, not images.

**Completion criterion:** Valid mermaid syntax that renders without errors.

## Step 4: Validate

- Diagram type matches content and audience
- All paths, states, or relationships covered
- Start/end states marked (flowcharts, state diagrams)
- Cardinality correct (ERDs)
- External systems identified (C4)
- Labels readable at target size
- Styling consistent if brand colors apply

**Completion criterion:** All items checked; diagram renders correctly in the target platform (GitHub, GitLab, Notion, etc.).

## Step 5: Present

Deliver the mermaid code block in markdown. If the platform doesn't render mermaid natively, note that [mermaid.live](https://mermaid.live) can be used for preview and export.

**Completion criterion:** Diagram delivered, rendering confirmed.
