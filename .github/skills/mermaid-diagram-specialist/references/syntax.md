# Mermaid Syntax Reference

## Flowchart

```mermaid
flowchart TD
    Start([Start]) --> Input[/User Input/]
    Input --> Validate{Valid?}
    Validate -->|Yes| Process[Process Data]
    Validate -->|No| Error[Show Error]
    Error --> Input
    Process --> Save[(Save to DB)]
    Save --> Success[/Success Response/]
    Success --> End([End])
```

**Node shapes:** `[Rectangle]` process, `([Rounded])` start/end, `{Diamond}` decision, `[/Parallelogram/]` I/O, `[(Database)]` storage, `((Circle))` connector.

**Directions:** `TD` top-down, `LR` left-right, `BT` bottom-up, `RL` right-left.

## Sequence Diagram

```mermaid
sequenceDiagram
    actor User
    participant Frontend
    participant API
    participant DB

    User->>Frontend: Click "Book"
    Frontend->>API: POST /api/bookings
    API->>DB: Check availability
    DB-->>API: Available
    API-->>Frontend: 201 Created
    Frontend-->>User: Show confirmation
```

**Participant types:** `actor` human, `participant` system, `database` DB.
**Arrows:** `->` sync, `-->` response, `->>` async, `-->>` async response.

## ERD

```mermaid
erDiagram
    USER ||--o{ BOOKING : creates
    USER {
        uuid id PK
        string email UK
        string name
    }
    BOOKING {
        uuid id PK
        uuid user_id FK
        date check_in
        date check_out
    }
```

**Relationships:** `||--||` one-to-one, `||--o{` one-to-many, `}o--o{` many-to-many, `||--o|` one-to-zero-or-one.
**Cardinality:** `||` exactly one, `o|` zero or one, `}o` zero or more, `}|` one or more.

## C4 Architecture

**Context level** — system in environment:

```mermaid
C4Context
    title System Context
    Person(guest, "Guest", "Tourist")
    System(platform, "Platform", "Booking system")
    System_Ext支付, "Payment", "Processor")
    Rel(guest, platform, "Books", "HTTPS")
    Rel(platform,支付, "Processes", "API")
```

**Container level** — applications and data stores:

```mermaid
C4Container
    Person(user, "User")
    Container(web, "Web App", "Astro + React", "Frontend")
    Container(api, "API", "Hono", "Backend")
    ContainerDb(db, "Database", "PostgreSQL", "Data")
    Rel(user, web, "Uses", "HTTPS")
    Rel(web, api, "Calls", "JSON/HTTPS")
    Rel(api, db, "Reads/Writes", "SQL")
```

**Component level** — internal structure:

```mermaid
C4Component
    Container(api, "API", "Hono")
    Component(routes, "Routes", "Hono Router", "Endpoints")
    Component(services, "Services", "Logic", "Domain ops")
    Component(models, "Models", "Data Access", "DB ops")
    Rel(routes, services, "Calls")
    Rel(services, models, "Uses")
```

## State Diagram

```mermaid
stateDiagram-v2
    [*] --> Pending
    Pending --> Confirmed : Payment Success
    Pending --> Cancelled : Payment Failed
    Confirmed --> CheckedIn : Check-in Date
    CheckedIn --> CheckedOut : Check-out Date
    Cancelled --> [*]
```

## Styling

```mermaid
%%{init: {'theme':'base', 'themeVariables': {
  'primaryColor':'#3B82F6',
  'primaryTextColor':'#fff',
  'primaryBorderColor':'#2563EB',
  'lineColor':'#6B7280'
}}}%%
flowchart TD
    A[Start] --> B[End]
```

**Class styling:**

```mermaid
flowchart TD
    A[Normal] --> B[Success]
    classDef successClass fill:#10B981,stroke:#059669,color:#fff
    class B successClass
```

## Common Patterns

**API request flow:**

```mermaid
sequenceDiagram
    Client->>+API: GET /resource
    API->>+Service: fetchResource()
    Service->>+Model: findById()
    Model->>+DB: SELECT
    DB-->>-Model: Row
    Model-->>-Service: Entity
    Service-->>-API: DTO
    API-->>-Client: JSON
```

**Error handling flow:**

```mermaid
flowchart TD
    Request[Request] --> Validate{Valid?}
    Validate -->|No| Error[Error Handler]
    Validate -->|Yes| Process[Process]
    Process --> DB{DB OK?}
    DB -->|No| Error
    DB -->|Yes| Success[Success]
    Error --> Log[Log] --> Response[Error Response]
```
