---
name: ml-paper-writing
description: Write publication-ready ML/AI papers for NeurIPS, ICML, ICLR, ACL, AAAI, COLM. Use when drafting papers from research repos, structuring arguments, verifying citations, or preparing camera-ready submissions. For systems venues (OSDI, NSDI, ASPLOS, SOSP), use systems-paper-writing instead.
---

# ML Paper Writing

Expert guidance for **NeurIPS, ICML, ICLR, ACL, AAAI, COLM**. For systems venues (OSDI, NSDI, ASPLOS, SOSP), use [systems-paper-writing](../systems-paper-writing/) instead.

## ⚠️ CRITICAL: Never Hallucinate Citations

AI-generated citations have a ~40% error rate. **Never write BibTeX from memory. Always fetch programmatically.**

- Found paper with DOI → fetch BibTeX via CrossRef/arXiv API ✅
- Cannot verify → mark `\cite{PLACEHOLDER_author2024_verify}` and tell the scientist ✅
- Guessing a plausible reference → **never** ❌

Full citation workflow (Semantic Scholar API, DOI fetch, placeholder rules): [references/citation-workflow.md](references/citation-workflow.md)

---

## Core Principle

**Be proactive. Deliver a draft, then iterate.**

1. Explore the repo (README, results, existing `.bib` files, experiment configs)
2. Confirm the one-sentence contribution with the scientist
3. Deliver a complete first draft — flag uncertainties inline, don't block on them
4. Iterate on feedback

---

## Paper Structure

Write in this order. Each step: draft → share → revise.

```
- [ ] 1. One-sentence contribution (confirm with scientist)
- [ ] 2. Figure 1
- [ ] 3. Abstract (5-sentence formula)
- [ ] 4. Introduction (1–1.5 pages max, contribution bullets, methods by p.2)
- [ ] 5. Methods (pseudocode, all hyperparameters, reproducibility details)
- [ ] 6. Experiments (state the claim each experiment tests; error bars required)
- [ ] 7. Related Work (methodological grouping, not paper-by-paper)
- [ ] 8. Limitations (required; honesty helps with reviewers)
- [ ] 9. Conference checklist → [references/checklists.md](references/checklists.md)
```

**Time allocation** (Neel Nanda): abstract ≈ introduction ≈ figures ≈ everything else combined. Reviewers read in order: title → abstract → intro → figures.

**Abstract formula** (Farquhar): (1) what you achieved, (2) why it's hard/important, (3) how you do it, (4) evidence, (5) best number.

---

## Writing Principles

Key rules — full guide with examples: [references/writing-guide.md](references/writing-guide.md)

- **One contribution**: state it in one sentence; if you can't, you don't have a paper yet
- **Stress position**: place the key result at the end of the sentence
- **Verbs not nominalizations**: "we analyzed" not "we performed an analysis"
- **No hedging**: drop "may," "can," "essentially," "basically," "very"
- **Consistent terminology**: pick one term per concept and never vary it
- **Specific over vague**: "accuracy" not "performance"; "15% lower latency" not "faster"
- **Minimize pronouns**: "this result shows" not "this shows"

---

## Conference Quick Reference

| Venue | Pages | Camera-ready | Required extras |
|-------|-------|-------------|-----------------|
| NeurIPS 2025 | 9 | +0 | Paper checklist; lay summary if accepted |
| ICML 2026 | 8 | +1 | Broader Impact Statement |
| ICLR 2026 | 9 | +1 | LLM usage disclosure |
| ACL 2025 | 8 | varies | Limitations + Ethics sections |
| AAAI 2026 | 7 | +1 | Strict style compliance (never edit `.sty`) |
| COLM 2025 | 9 | +1 | Language model focus |

Universal: double-blind, references don't count, LaTeX required, appendices unlimited.

Templates in [templates/](templates/) — always copy the **entire** directory, not just `main.tex`.

---

## Format Conversion (Resubmission)

**Never merge preambles.** Start with the target template; copy only content sections.

| From → To | Page Δ | Key action |
|-----------|--------|-----------|
| NeurIPS → ICML | −1 | Cut; add Broader Impact |
| ICML → ICLR | +1 | Expand; add LLM disclosure |
| Any → AAAI | −2 to −3 | Significant cuts; strict style |
| Any → ACL | varies | Add Limitations + Ethics |

When cutting: move proofs to appendix, cite surveys instead of individual papers, combine tables, tighten prose.

---

## Tables and Figures

- **Figures**: vector (PDF/EPS) for plots; raster (PNG 600 DPI) only for photos; colorblind-safe palette (Okabe-Ito); verify grayscale readability; captions must be self-contained
- **Tables**: use `booktabs`; bold best value per metric; include direction symbols (↑/↓); consistent decimal precision

---

## References

| Document | Contents |
|----------|----------|
| [references/citation-workflow.md](references/citation-workflow.md) | Semantic Scholar API, DOI→BibTeX, placeholder rules |
| [references/writing-guide.md](references/writing-guide.md) | Gopen & Swan 7 principles, Perez micro-tips, Lipton word choice |
| [references/checklists.md](references/checklists.md) | NeurIPS, ICML, ICLR, ACL, AAAI submission checklists |
| [references/reviewer-guidelines.md](references/reviewer-guidelines.md) | Evaluation criteria, scoring scales, rebuttal tips |
| [references/sources.md](references/sources.md) | Full bibliography (Nanda, Farquhar, Steinhardt, et al.) |
| [templates/](templates/) | LaTeX templates for all venues |
