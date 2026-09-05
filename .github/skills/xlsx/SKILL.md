---
name: xlsx
description: Use when the deliverable is a spreadsheet (.xlsx) the user wants created, edited, analyzed, or cleaned.
---

# XLSX creation, editing, and analysis

## Requirements for all Excel files

- **Professional font** — consistent (e.g. Arial, Times New Roman) unless otherwise instructed.
- **Zero formula errors** — every deliverable ships with ZERO formula errors (`#REF!`, `#DIV/0!`, `#VALUE!`, `#N/A`, `#NAME?`).
- **Preserve existing templates** — when updating, study and EXACTLY match existing format, style, and conventions. Existing template conventions ALWAYS override these guidelines.

## When NOT to use

- The output is not a spreadsheet (CSV/Parquet is sufficient) — don't force `.xlsx`.
- Only reading/analyzing an existing sheet without editing — use `data-access` (`read` via DuckDB `excel` extension) instead.

## Financial models

Only apply this section when the user explicitly requests a financial model — don't impose it on simple spreadsheets.

- Color coding standards and number formatting: `references/color-coding.md`.
- **Assumptions placement** — all assumptions (growth rates, margins, multiples) in separate cells; formulas use cell references, never hardcoded values: `=B5*(1+$B$6)` not `=B5*1.05`.
- **Documentation for hardcodes** — comment or annotate beside the cell: "Source: [System/Document], [Date], [Specific Reference], [URL if applicable]" (e.g. "Source: Company 10-K, FY2024, Page 45, Revenue Note, [SEC EDGAR URL]").

## Tools

Use **pandas** for data analysis and bulk operations; **openpyxl** for formulas, formatting, and Excel-specific features. pandas: specify dtypes (`dtype={'id': str}`), use `usecols` for large files, handle dates with `parse_dates`. openpyxl: use `read_only=True` / `write_only=True` for large files; cell indices are 1-based.

```python
import pandas as pd
df = pd.read_excel('file.xlsx')
df.to_excel('output.xlsx', index=False)
```

**CRITICAL: Use formulas, not hardcoded values.** The spreadsheet must recalculate when source data changes.

```python
# Wrong: sheet['B10'] = df['Sales'].sum()  # hardcodes 5000
# Right:
sheet['B10'] = '=SUM(B2:B9)'
```

## Workflow

1. **Choose tool** — pandas for data, openpyxl for formulas/formatting.
2. **Create/Load** — new workbook or existing file.
3. **Modify** — add/edit data, formulas, and formatting.
4. **Save** — write to file.
5. **Recalculate formulas (MANDATORY IF USING FORMULAS):** `python scripts/recalc.py output.xlsx` (LibreOffice recalculates; the script auto-configures it on first run, including sandboxed environments via `scripts/office/soffice.py`).
6. **Verify and fix errors** — the script returns JSON: if `status` is `errors_found`, check `error_summary` for error types/locations, fix, recalculate again. Error types enumerated in Zero Formula Errors above.
7. **Validate (required for files > 10 rows):**
   - **Row-wise type guards** — every cell matches its expected dtype (numeric cells numeric, date cells parse, string cells non-null)
   - **Formula sanity** — sample ≥3 derived/formula cells; recompute in Python and confirm within 0.01
   - **Date preservation** — date-formatted cells are `datetime` (not strings), serial dates have the correct number format
   - **Range bounds** — `SUM`/`AVERAGE`/`COUNT` ranges don't include header rows or exceed the data
   - Report all violations; fix before proceeding.

## Formula Verification Checklist

- [ ] Test 2-3 sample references before building full model
- [ ] **Column mapping**: Excel columns match (e.g., column 64 = BL, not BK)
- [ ] **Row offset**: Excel rows are 1-indexed (DataFrame row 5 = Excel row 6)
- [ ] **NaN handling**: check for null values with `pd.notna()`
- [ ] **Far-right columns**: FY data often in columns 50+
- [ ] **Multiple matches**: search all occurrences, not just first
- [ ] **Division by zero**: check denominators before using `/` in formulas
- [ ] **Cross-sheet references**: use correct format (Sheet1!A1)
- [ ] **No circular references**: verify none are unintended
- [ ] **Consistent formulas** across all projection periods
- [ ] **Edge cases**: test with zero values and negative numbers

> Reading `data_only=True` returns calculated values, but **saving after `data_only=True` replaces formulas with values permanently.**