# Coverage & Unknowns

Coverage describes what the current SIJI snapshot can answer for a particular query.

Useful states include:

- **complete** — the declared result scope is covered;
- **partial** — usable results are available with remaining gaps;
- **unknown** — completeness is not established;
- **unavailable / restricted** — the requested data is currently unavailable to the caller;
- **unsupported / not found in scope** — the current snapshot has no supporting result for the request;
- **conflict** — published evidence or assertions disagree.

Read coverage together with the query scope, object type, snapshot time, and evidence state. Different product layers and companies can have different coverage at the same time.
