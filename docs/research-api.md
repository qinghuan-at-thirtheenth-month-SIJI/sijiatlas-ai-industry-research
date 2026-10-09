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

Send the key in the `X-API-Key` header. Research Units (RU) measure request usage; Disclosure Units (DU) separately limit newly delivered structured content. All keys in an account share these limits.

With `SIJI_API_KEY` set in your environment, request the industry overview:

```bash
curl --fail-with-body 'https://sijiatlas.com/v1/agent/world/overview' \
  -H "X-API-Key: $SIJI_API_KEY" \
  -H 'Content-Type: application/json' \
  -H 'Idempotency-Key: overview-1' \
  --data '{}'
```

Ready-to-run equivalents are available for [Python 3](../examples/api/world_overview.py), [Windows PowerShell 5.1+](../examples/api/world_overview.ps1), and [POSIX shell + cURL](../examples/api/world_overview.sh). Set `SIJI_API_KEY` privately in the process environment and choose `SIJI_IDEMPOTENCY_KEY` for this logical request. Run one client from the repository root:

```text
python examples/api/world_overview.py
powershell -NoProfile -File examples/api/world_overview.ps1
sh examples/api/world_overview.sh
```

These clients send the same default `{}` request and do not retry automatically. Successful output contains the JSON response followed by a separate `SIJI_HTTP_STATUS=200` line; remove that final status line before parsing the output as JSON.

Production verification on 2026-10-09 observed **12 RU** for the first default `{}` world overview. Python, Windows PowerShell and Linux cURL calls with the same key, request and idempotency key returned the same delivery and response hash; the two replays each charged **0 RU** with `usage.replayed=true`. This is the measured default example; use the response's actual RU charge for other requests.

To begin the [Context Memory case](../examples/next-inflection.md), resolve the product:

```bash
curl --fail-with-body 'https://sijiatlas.com/v1/agent/entities/search' \
  -H "X-API-Key: $SIJI_API_KEY" \
  -H 'Content-Type: application/json' \
  -H 'Idempotency-Key: context-memory-1' \
  --data '{"query":"Context Memory","entity_types":["product"],"limit":5}'
```

The operation is selected by the HTTP path. Entities are returned in `data.nodes`. Build a typed reference from a node's returned `type` and `id`; for positions, also retain its `chain_version_id`. Pass these references in `entity_refs` for `get_entities`, `seeds` for `expand_graph`, or `subject_refs` for `get_facts`. Reuse an edge's full `relationship_ref` when reopening it. Use `data.facts[].fact_id` values in `fact_ids` for `get_evidence`. Do not infer a reference type from the entity name or assume every target is a product; use the returned `type`, including `business`.

## Continuation

When `pagination.has_more` is true, copy `pagination.next_cursor` into the next request's `cursor` field and preserve the original logical request parameters. Retain the returned `session_id` when continuing a research session. Use the cursor unchanged; a cursor is bound to its account, query and snapshot.

Keep the same `Idempotency-Key` when retrying an identical request. Use a new key for a new request, including the next cursor page. An identical replay within 24 hours returns `usage.replayed=true` and `usage.charged_ru=0`. Reusing a key with a different request returns HTTP 409. A replay reuses the original delivery; cached remaining-balance fields can reflect that original settlement. Refresh the API Console for current account balances.

Agent responses include `snapshot_id`, `data_as_of`, `status`, `coverage`, `pagination`, and `usage`. Read `usage.charged_ru` (also `X-Research-RU`) for the charge. Keep `partial` results and their continuation state explicit.

A successfully delivered empty Agent page currently costs **1 RU**, except for an explicit free baseline page. Rejected or failed requests do not settle RU; if the network outcome is unknown, retry with the original idempotency key. `/v1/research` has separate supported-subject pricing: an unsupported or zero-supported-subject packet costs **0 RU**, rather than following the Agent empty-page rule.

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

## RU and DU limits

RU and DU are independent. DU is based on newly delivered public content, not a fixed number of companies, facts or HTTP requests. DU limits apply across keys and transports over **rolling 31-day and one-hour windows**, separately from the RU allowance period and rolling 24-hour RU limit.

Some DU is reserved for follow-up verification of previously delivered objects. This reserve is not ordinary new-content capacity. Capacity returns as earlier charges leave each rolling window, rather than at a calendar-month boundary or the top of the hour. Gift or top-up RU does not raise the current plan's DU limits; an account can have RU remaining while a DU limit prevents new delivery.

## Errors and limits

Errors use `error.code`, `error.message`, and `error.request_id`.

| HTTP status | Meaning |
| --- | --- |
| `401` | API key missing or invalid |
| `402` | Insufficient account RU or new-content DU; inspect `error.code` |
| `403` | Key, scope or plan does not allow the request |
| `409` | Idempotency conflict or continuation no longer usable |
| `413` | Request body exceeds the allowed size |
| `422` | Invalid request fields or unsupported combination |
| `429` | Request, concurrency, rolling 24-hour RU, rolling-hour DU or access limit; follow `Retry-After` when present |
| `503` | Service or published snapshot unavailable; no RU charged |

`RESEARCH_QUOTA_EXHAUSTED` identifies insufficient RU. `RESEARCH_DISCLOSURE_QUOTA_EXHAUSTED` identifies insufficient DU in the rolling 31-day window. `RESEARCH_DISCLOSURE_VELOCITY_LIMIT` identifies the rolling-hour DU limit, rather than the ordinary requests-per-minute limit; follow its `Retry-After` value before retrying.

## Machine-readable contracts

- [Capability catalog](../api/capabilities.json)
- [OpenAPI](../api/openapi.json)
- [Live Agent capability catalog](https://sijiatlas.com/v1/agent/capabilities) — public request and response schemas
- [Live Research packet contract](https://sijiatlas.com/v1/research/openapi)
