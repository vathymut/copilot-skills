# Spatial queries (extracted from SKILL.md § spatial)

Always start with:

```sql
LOAD spatial; SET geometry_always_xy = true;
```

Key patterns:

- Real-world places / POIs / buildings / roads (no user file) → Overture Maps: `references/overture.md`.
- Distance / containment / conversion → `references/functions.md`.
- Density / hotspots → H3 hex binning: `INSTALL h3 FROM community; LOAD h3;`.

Principles: bbox-filter first (Parquet pushdown), `geometry_always_xy = true`, use `ST_Distance_Spheroid` for real-world distances, CSV lat/lng → `ST_Point(longitude, latitude)`.
