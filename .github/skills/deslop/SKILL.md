---
name: deslop
description: Remove AI-generated code slop and clean up code style. Use when asked to "deslop", "remove slop", "clean up AI code", or "tidy the diff".
---

## Steps

### 1. Read the diff

Get the diff against main. Understand what changed and why.

### 2. Identify slop patterns

Scan for these anti-patterns in the diff:
- Extra comments unnecessary or inconsistent with local style
- Defensive checks or try/catch blocks abnormal for trusted code paths
- Casts to `any` / `type: ignore` / broad `except Exception` used only to bypass type issues
- Deeply nested code that should use early returns
- Other patterns inconsistent with the surrounding codebase

### 3. Remove slop

Apply minimal, focused edits. Keep behavior unchanged unless fixing a clear bug. Remove each slop pattern while preserving intended functionality.

### 4. Verify behavior preserved

Confirm the diff now contains only intentional, non-slop changes. Behavior must match the original intent.

## Completion criteria

- No unnecessary comments, defensive boilerplate, or type bypasses remain
- Code matches surrounding codebase style
- Behavior is unchanged from the original diff intent
- Summary is 1-3 sentences
