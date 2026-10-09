# SIJI Agent Graph API

SIJI exposes nine typed operations over its maintained AI-industry graph.

Base URL: **https://sijiatlas.com**. [Create an account](https://sijiatlas.com/register), verify your email, then create a key in the [API Console](https://sijiatlas.com/account/api).

| Operation | HTTP path | MCP tool |
| --- | --- | --- |
| `get_world_overview` | `POST /v1/agent/world/overview` | `siji_get_world_overview` |
| `search_entities` | `POST /v1/agent/entities/search` | `siji_search_entities` |
| `get_entities` | `POST /v1/agent/entities/get` | `siji_get_entities` |
| `list_changes` | `POST /v1/agent/changes/list` | `siji_list_changes` |
| `expand_graph` | `POST /v1/agent/graph/expand` | `siji_expand_graph` |
| `trace_paths` | `POST /v1/agent/graph/paths` | `siji_trace_paths` |
| `get_facts` | `POST /v1/agent/facts/get` | `siji_get_facts` |
| `get_evidence` | `POST /v1/agent/evidence/get` | `siji_get_evidence` |
| `compare` | `POST /v1/agent/compare` | `siji_compare` |

## Authentication

Send the key in the `X-API-Key` header. Account usage is measured in Research Units (RU); keys in the same account share its allowance.

With `SIJI_API_KEY` set in your environment, request the industry overview:

```bash
curl --fail-with-body 'https://sijiatlas.com/v1/agent/world/overview' \
  -H "X-API-Key: $SIJI_API_KEY" \
  -H 'Content-Type: application/json' \
  -H 'Idempotency-Key: overview-1' \
  --data '{}'
```

To begin the [Context Memory case](../examples/next-inflection.md), resolve the product:

```bash
curl --fail-with-body 'https://sijiatlas.com/v1/agent/entities/search' \
  -H "X-API-Key: $SIJI_API_KEY" \
  -H 'Content-Type: application/json' \
  -H 'Idempotency-Key: context-memory-1' \
  --data '{"query":"Context Memory","entity_types":["product"],"limit":5}'
```

The operation is selected by the HTTP path. Entities are returned in `data.nodes`. Build a typed reference from a node's returned `type` and `id`; for positions, also retain its `chain_version_id`. Pass these references in `entity_refs` for `get_entities`, `seeds` for `expand_graph`, or `subject_refs` for `get_facts`. Reuse an edge's full `relationship_ref` when reopening it. Use `data.facts[].fact_id` values in `fact_ids` for `get_evidence`.

## Continuation

When `pagination.has_more` is true, copy `pagination.next_cursor` into the next request's `cursor` field and preserve the original logical request parameters. Retain the returned `session_id` when continuing a research session. Use the cursor unchanged; a cursor is bound to its account, query and snapshot.

Keep the same `Idempotency-Key` when retrying an identical request. Use a new key for a new request, including the next cursor page. An identical replay within 24 hours returns `usage.replayed=true` and `usage.charged_ru=0`. Reusing a key with a different request returns HTTP 409.

Agent responses include `snapshot_id`, `data_as_of`, `status`, `coverage`, `pagination`, and `usage`. Read `usage.charged_ru` (also `X-Research-RU`) for the charge. Keep `partial` results and their continuation state explicit.

## Research packets

`POST /v1/research` uses the same key and account allowance. It supports `company`, `product`, `industry`, `compare`, and `changes` modes. For a product returned by entity search, use its stable ID:

```json
{
  "mode": "product",
  "query": {"product_id": "<returned product id>"},
  "select": ["overview", "positions", "companies", "claims", "sources"],
  "depth": "standard",
  "response": "json"
}
```

## Errors and limits

Errors use `error.code`, `error.message`, and `error.request_id`.

| HTTP status | Meaning |
| --- | --- |
| `401` | API key missing or invalid |
| `402` | Insufficient account RU |
| `403` | Key, scope or plan does not allow the request |
| `409` | Idempotency conflict or continuation no longer usable |
| `413` | Request body exceeds the allowed size |
| `422` | Invalid request fields or unsupported combination |
| `429` | Request, concurrency, daily usage or access limit; follow `Retry-After` when present |
| `503` | Service or published snapshot unavailable; no RU charged |

## Machine-readable contracts

- [Capability catalog](../api/capabilities.json)
- [OpenAPI](../api/openapi.json)
- [Live Agent capability catalog](https://sijiatlas.com/v1/agent/capabilities) — public request and response schemas
- [Live Research packet contract](https://sijiatlas.com/v1/research/openapi)
