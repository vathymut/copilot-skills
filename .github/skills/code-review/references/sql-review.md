# SQL Review

Reference for the SQL axis of `code-review` Branch A. Review SQL in the
selection (or the whole project) through the steps below; consult the
Database-Specific section for platform syntax.

## 1. Scope

Read the full SQL under review. Identify every statement (SELECT/INSERT/UPDATE/
DELETE/DDL) and whether external input flows into any statement (application
context).

## 2. Injection (CRITICAL)

Inspect every statement that accepts or interpolates external input. Flag each
as CRITICAL and give a parameterized rewrite using the platform's bind syntax
(`$1` / `?` / `@id` / `:bind`):

- String concatenation building SQL (`"SELECT ... " + variable`, `f"..."`).
- Dynamic SQL without parameterization (`EXECUTE IMMEDIATE`, `sp_executesql`
  with concatenated strings).
- Stored procedures/functions that build SQL from arguments.

## 3. Anti-patterns

| Anti-pattern | What to look for |
|---|---|
| **SELECT \*** | Explicit `SELECT *` / `table.*` where specific columns are expected. |
| **DISTINCT as crutch** | `DISTINCT` masking a join that produces duplicate rows. |
| **Functions in WHERE** | `YEAR()`/`UPPER()`/`DATE()` on columns in predicates, blocking index use. |
| **Implicit joins** | Comma-separated `FROM` with join conditions in `WHERE`. |
| **Correlated subqueries** | Subquery in SELECT/WHERE referencing the outer row-by-row. |
| **Missing LIMIT on bulk DML** | `UPDATE`/`DELETE` without a `WHERE`/`LIMIT` touching the whole table. |

## 4. Performance

- **Index alignment:** do `WHERE`/`JOIN ... ON` columns have indexes? Is a
  composite index ordered for the query's selectivity?
- **Join type:** is INNER/LEFT/EXISTS/IN appropriate? Flag unnecessary
  `LEFT JOIN` that could be `INNER`.
- **Cartesian risk:** are all join conditions present?
- **Aggregate efficiency:** set-based logic over row-by-row subqueries?

## 5. Present findings

Group by severity (injection > anti-pattern > performance). For each: location,
category, issue, and a corrected query. End with the highest-priority actions
ordered by severity.
