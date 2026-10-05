# How SIJI Works

SIJI organizes AI-industry research around stable objects and reusable references.

## Core path

```text
Product / business
→ Industry position
→ Company participation
→ Commercial fact
→ Evidence
→ Original source
```

A researcher can enter at any point in this chain and continue outward.

## World overview

`get_world_overview` returns a lightweight map of the current published industry world. It gives an Agent a broad set of companies, products/businesses, positions, and typed relationships before deeper calls.

## Drill-down

After choosing an object:

- `get_entities` reopens its identity and context;
- `expand_graph` explores nearby relationships;
- `trace_paths` finds bounded routes;
- `get_facts` reads commercial and operating facts;
- `get_evidence` opens the evidence/source layer;
- `list_changes` tracks published changes;
- `compare` aligns selected objects.

## Freshness

SIJI provides a maintained snapshot and published change stream. Public Web sources can extend the research when a newer event falls outside the current snapshot.
