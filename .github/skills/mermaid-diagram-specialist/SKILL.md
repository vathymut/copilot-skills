---
name: mermaid-diagram-specialist
description: Use when a diagram belongs in documentation as Mermaid — flowcharts, sequence diagrams, ERDs, or architecture and state diagrams. For data charts and figures, use tufte-data-viz instead.
disable-model-invocation: true
---

# Mermaid Diagram Specialist

## Step 1: Choose diagram type

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

**Completion criterion:** Diagram type chosen with audience and key elements identified.

## Step 2: Draft the mermaid syntax

Write the diagram code following these principles: simplicity (under 20 nodes), clear labels, consistent flow direction, subgraphs for grouping, and notes for complex logic. Keep diagram source in markdown files, not images.

**Completion criterion:** Valid mermaid syntax that renders without errors.

## Step 3: Validate

Run through [mermaid.live](https://mermaid.live) or the platform renderer; fix any errors.

**Completion criterion:** Diagram renders correctly in the target platform.

## Step 4: Present

Deliver the mermaid code block in markdown. If the platform doesn't render mermaid natively, note that [mermaid.live](https://mermaid.live) can be used for preview and export.

**Completion criterion:** Diagram delivered, rendering confirmed.
