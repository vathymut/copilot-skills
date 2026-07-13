---
name: web-design-reviewer
description: Visually inspect websites to identify and fix design issues at the source code level. Use when the user asks to review, check, or fix website design, UI, layout, or responsive/acce---

# Web Design Reviewer

Visual inspection and validation of website design quality, identifying and fixing issues at the source code level.

## Prerequisites

1. **Target website must be running** — local dev server, staging, or production (read-only)
2. **Browser automation must be available** — screenshot capture, page navigation, DOM retrieval
3. **Access to source code** (when making fixes) — project must exist within the workspace

## Workflow

```mermaid
flowchart TD
    A[Step 1: Information Gathering] --> B[Step 2: Visual Inspection]
    B --> C[Step 3: Issue Fixing]
    C --> D[Step 4: Re-verification]
    D --> E{Issues Remaining?}
    E -->|Yes| B
    E -->|No| F[Completion Report]
```

---

## Step 1: Information Gathering

### 1.1 URL Confirmation

If the URL is not provided, ask the user for it.

### 1.2 Understanding Project Structure

When making fixes, gather: framework (React/Vue/Next.js/etc.), styling method (CSS/SCSS/Tailwind/CSS-in-JS), source file locations, and review scope.

### 1.3 Automatic Project Detection

Detect from workspace files: `package.json` → framework/deps, `tsconfig.json` → TypeScript, `tailwind.config` → Tailwind, `next.config` → Next.js, `vite.config` → Vite, `nuxt.config` → Nuxt, `src/` or `app/` → source dir.

### 1.4 Identifying Styling Method

| Method | Detection | Edit Target |
|--------|-----------|-------------|
| Pure CSS | `*.css` files | Global or component CSS |
| SCSS/Sass | `*.scss`, `*.sass` | SCSS files |
| CSS Modules | `*.module.css` | Module CSS files |
| Tailwind CSS | `tailwind.config.*` | className in components |
| styled-components | `styled.` in code | JS/TS files |
| Emotion | `@emotion/` imports | JS/TS files |
| CSS-in-JS (other) | Inline styles | JS/TS files |

---

## Step 2: Visual Inspection

### 2.1 Page Traversal

Navigate to the URL, capture screenshots, retrieve DOM structure, and traverse additional pages if they exist.

### 2.2 Inspection Categories

**Layout:** element overflow, overlap, alignment issues, inconsistent spacing, text clipping.

**Responsive:** non-mobile-friendly layouts, breakpoint issues, touch targets too small.

**Accessibility:** insufficient contrast, no focus state, missing alt text.

**Visual Consistency:** font inconsistency, color inconsistency, spacing inconsistency.

### 2.3 Viewport Testing

Test at: Mobile (375px), Tablet (768px), Desktop (1280px), Wide (1920px).

---

## Step 3: Issue Fixing

### 3.1 Priority Matrix

- **P1:** Layout issues affecting functionality — fix immediately
- **P2:** Visual issues degrading UX — fix next
- **P3:** Minor visual inconsistencies — fix if possible

### 3.2 Identifying Source Files

1. **Selector-based Search** — search by class name or ID
2. **Component-based Search** — identify components from element text/structure
3. **File Pattern Filtering** — `src/**/*.css`, `styles/**/*`, `src/components/**/*`, `src/pages/**`, `app/**`

### 3.3 Applying Fixes

See [references/framework-fixes.md](references/framework-fixes.md) for framework-specific guidelines.

**Principles:** minimal changes, respect existing patterns, avoid breaking changes, add comments where appropriate.

---

## Step 4: Re-verification

1. Reload browser / wait for HMR
2. Capture screenshots of fixed areas, compare before/after
3. Verify no regressions in other areas or responsive display
4. If more than 3 fix attempts are needed for a specific issue, consult the user

---

## Output Format

```markdown
# Web Design Review Results

## Summary
| Item | Value |
|------|-------|
| Target URL | {URL} |
| Framework | {Detected framework} |
| Styling | {CSS / Tailwind / etc.} |
| Tested Viewports | Desktop, Mobile |
| Issues Detected | {N} |
| Issues Fixed | {M} |

## Detected Issues
### [P1] {Issue Title}
- **Page**: {Page path}
- **Element**: {Selector or description}
- **Issue**: {Detailed description}
- **Fixed File**: `{File path}`
- **Fix Details**: {Description of changes}
- **Screenshot**: Before/After

## Unfixed Issues (if any)
### {Issue Title}
- **Reason**: {Why it was not fixed}
- **Recommended Action**: {Recommendations}

## Recommendations
- {Suggestions for future improvements}
```

---

## Best Practices

**DO:** save screenshots before fixing, fix one issue at a time and verify each, follow existing code style, confirm with user before major changes, document fix details.

**DON'T:** large-scale refactor without confirmation, ignore design systems/brand guidelines, ignore performance, fix multiple issues at once.

---

## Troubleshooting

- **Style files not found:** check `package.json` deps, consider CSS-in-JS or build-time CSS, ask user
- **Fixes not reflected:** check HMR, clear cache, rebuild, check CSS specificity
- **Fixes affecting other areas:** rollback, use more specific selectors, consider CSS Modules/scoped styles
