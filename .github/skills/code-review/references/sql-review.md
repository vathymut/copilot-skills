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
as CRITICAL and give a parameterized rewrite:

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

---

# Database-Specific Syntax Reference

Platform-specific patterns and idioms for PostgreSQL, MySQL, SQL Server, and Oracle.

## PostgreSQL

```sql
-- JSONB for structured JSON data
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- GIN index for JSONB containment queries
CREATE INDEX idx_events_data ON events USING gin(data);

-- Array types for multi-value columns
CREATE TABLE tags (
    post_id INT,
    tag_names TEXT[]
);

-- Parameterized query
PREPARE stmt AS SELECT * FROM users WHERE id = $1;
EXECUTE stmt(42);
```

## MySQL

```sql
-- InnoDB for transactions and row-level locking
CREATE TABLE sessions (
    id VARCHAR(128) PRIMARY KEY,
    data TEXT,
    expires TIMESTAMP
) ENGINE=InnoDB;

-- Covering index for frequent queries
ALTER TABLE large_table
ADD INDEX idx_covering (status, created_at, id);

-- Parameterized query
PREPARE stmt FROM 'SELECT * FROM users WHERE id = ?';
SET @uid = 42;
EXECUTE stmt USING @uid;
```

## SQL Server

```sql
-- Appropriate data types and defaults
CREATE TABLE products (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at DATETIME2 DEFAULT GETUTCDATE()
);

-- Columnstore for analytics workloads
CREATE COLUMNSTORE INDEX idx_sales_cs ON sales;

-- Parameterized query
EXEC sp_executesql
    N'SELECT * FROM users WHERE id = @id',
    N'@id INT',
    @id = 42;
```

## Oracle

```sql
-- Sequences for auto-increment
CREATE SEQUENCE user_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE users (
    id NUMBER DEFAULT user_id_seq.NEXTVAL PRIMARY KEY,
    name VARCHAR2(255) NOT NULL
);

-- Bind variables for parameterized queries
SELECT * FROM users WHERE id = :bind_id;
```
