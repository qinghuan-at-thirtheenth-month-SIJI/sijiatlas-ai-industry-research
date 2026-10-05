# SIJI Agent Graph API

SIJI exposes nine typed operations over its maintained AI-industry graph.

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

Requests use an SIJI API Key. Account usage is measured in Research Units (RU).

## Continuation

When an operation returns a cursor, continue with the same logical request and the returned cursor. Reuse returned entity, relationship, fact, and source references for subsequent calls.

## Machine-readable contracts

- [Capability catalog](../api/capabilities.json)
- [OpenAPI](../api/openapi.json)
