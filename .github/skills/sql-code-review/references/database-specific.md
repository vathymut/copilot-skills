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
