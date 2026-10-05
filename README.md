# SIJI — AI Industry Intelligence for Researchers and Agents

**SIJI connects companies, products, industry positions, commercial relationships, facts, evidence, and original-source references into a researchable AI-industry map.**

Use it when ordinary Web research becomes fragmented and you need to move between a product layer, the companies participating in it, recent changes, and the evidence behind each claim.

[中文说明](README.zh-CN.md)

## What you can research

- AI infrastructure products and product layers
- upstream, downstream, adjacent, and alternative technical routes
- company participation, customers, suppliers, cooperation, orders, capacity, shipments, delivery, and commercialization
- recent published changes for selected companies or products
- the evidence and original sources behind a fact or relationship
- comparisons across a small set of explicit candidates

## Start here

- **Researchers:** [Human guide](docs/human-guide.md)
- **AI agents:** [Agent guide](docs/agent-guide.md)
- **Research API:** [API guide](docs/research-api.md)
- **Context Memory case:** [examples/next-inflection.md](examples/next-inflection.md)
- **Machine-readable capabilities:** [api/capabilities.json](api/capabilities.json)
- **OpenAPI:** [api/openapi.json](api/openapi.json)

## Research flow

For an open industry question:

```text
world overview
→ choose relevant products / positions / companies
→ inspect changes and graph relationships
→ read facts
→ open evidence and original sources
```

For a known company or product, start with entity search and continue directly from the returned references.

## Agent Graph

SIJI currently exposes nine typed research operations:

- `get_world_overview`
- `search_entities`
- `get_entities`
- `list_changes`
- `expand_graph`
- `trace_paths`
- `get_facts`
- `get_evidence`
- `compare`

Each operation returns stable references that can be reused in the next call.

## Example: Context Memory

Starting from **Context Memory**, SIJI resolves **Huawei OceanStor M900 Context Memory Storage** and connects the product to both:

- **NVMe-oF / distributed storage**
- **Prefill / Decode / KV Cache**

From there, a researcher can continue into other products at the same positions, participating companies, commercialization facts, and source evidence.

[Read the case](examples/next-inflection.md).

## Coverage and evidence

Every result carries its own state and scope. `verified`, `review_required`, `conflict`, `partial`, and other states stay attached to the item they describe. Coverage is reported for the current query and snapshot.

See [Coverage & Unknowns](docs/coverage-and-unknowns.md) and [Evidence & Sources](docs/evidence-and-sources.md).
