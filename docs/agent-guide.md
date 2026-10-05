# SIJI Agent Guide

Use SIJI as a structured source of AI-industry entities, relationships, facts, evidence, and published changes.

## Choose a starting point

For broad industry research, begin with `get_world_overview`. It returns the current visible companies, products/businesses, industry positions, and typed relationship skeleton.

For a known company or product, start with `search_entities` and `get_entities`.

## Typical loop

```text
get_world_overview or search_entities
→ get_entities
→ list_changes / expand_graph / trace_paths
→ get_facts
→ get_evidence
→ compare when needed
```

Use the typed references returned by SIJI in follow-up calls.

## Operation guide

- `get_world_overview` — current industry map and coverage context
- `search_entities` — resolve names, aliases, codes, products, and positions
- `get_entities` — reopen returned entities
- `list_changes` — recent published changes or tracked-object updates
- `expand_graph` — explore relationships around an entity
- `trace_paths` — bounded routes between explicit objects
- `get_facts` — qualified facts with state, time, scope, and citations
- `get_evidence` — evidence and source references
- `compare` — align selected objects on the same dimensions

## Reading results

Preserve the relationship type, fact type, evidence state, time scope, and coverage returned with each item. Keep `partial`, `unknown`, and `conflict` states visible when they appear.

For information newer than the current SIJI snapshot, continue from the returned source anchors with public Web research.
