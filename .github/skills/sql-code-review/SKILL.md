---
name: sql-code-review
description: >-
  Review SQL code for injection vulnerabilities, anti-patterns, and performance
  issues. Use when asked to review, audit, or check SQL code.
---

# SQL Code Review

Review SQL in `${selection}` (or the entire project if no selection) through a
structured, five-step process. For platform-specific syntax examples, consult
[`references/database-specific.md`](references/database-specific.md).

## Steps

### 1. Read and scope

Read the full SQL under review. Identify:
- Every statement (SELECT, INSERT, UPDATE, DELETE, DDL).
- Whether user input flows into any statement (application code context).
- The target database platform, if determinable.

**Done when:** you can name every statement and whether it handles external input.

### 2. Check for injection vulnerabilities

Inspect every statement that accepts or interpolates external input.

**Find all of:**
- String concatenation building SQL (`"SELECT ... " + variable`, `f"..."`).
- Dynamic SQL without parameterization (`EXECUTE IMMEDIATE`, `sp_executesql`
  with concatenated strings).
- Stored procedures or functions that build SQL from arguments.

**Flag each as CRITICAL.** Provide the vulnerable line and a parameterized
rewrite.

**Done when:** every statement handling external input has been checked for
injection, and all findings have concrete fixes.

### 3. Check for anti-patterns

Scan for these defects. For each, cite the line and provide the corrected query.

| Anti-pattern | What to look for |
|---|---|
| **SELECT \*** | Explicit `SELECT *` or `table.*` in queries that should project specific columns. |
| **DISTINCT as crutch** | `DISTINCT` masking a join that produces duplicate rows — the join condition or query structure is wrong. |
| **Functions in WHERE** | `YEAR()`, `UPPER()`, `DATE()` applied to columns in predicates, preventing index use. Rewrite as range or sargable condition. |
| **Implicit joins** | Comma-separated `FROM` tables with join conditions in `WHERE`. Rewrite as explicit `JOIN ... ON`. |
| **Correlated subqueries** | A subquery in `SELECT` or `WHERE` that references the outer query row-by-row. Rewrite as a `JOIN` or window function. |
| **Missing LIMIT on bulk DML** | `UPDATE` or `DELETE` without a `WHERE` or `LIMIT` that will touch the entire table. |

**Done when:** every statement has been checked against each row in this table,
and all findings have line references and rewrites.

### 4. Check for performance issues

Inspect query structure and data access patterns.

- **Index alignment:** Do `WHERE` and `JOIN ... ON` columns have indexes? Are
  composite indexes ordered for the query's selectivity?
- **Join type:** Is the join type (INNER, LEFT, EXISTS, IN) appropriate for the
  cardinality intent? Flag unnecessary `LEFT JOIN` that could be `INNER`.
- **Cartesian risk:** Are all join conditions present? A missing condition is a
  cartesian product.
- **Aggregate efficiency:** Are aggregations using set-based logic instead of
  row-by-row subqueries?

**Done when:** every query's join structure and index assumptions have been
evaluated, and all inefficiencies have concrete rewrites.

### 5. Present findings

Group findings by severity. For each finding:

- **Location:** statement or line number.
- **Category:** injection, anti-pattern, or performance.
- **Issue:** what is wrong and why.
- **Fix:** the corrected SQL.

End with a summary of the highest-priority actions, ordered by severity
(critical > high > medium > low).

**Done when:** all findings from steps 2-4 are reported with locations, categories,
and fixes.
