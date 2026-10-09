"""Call SIJI's default world overview with Python's standard library.

Set SIJI_API_KEY privately in the process environment. Use the same
SIJI_IDEMPOTENCY_KEY when retrying this exact request. No automatic retry.
The final SIJI_HTTP_STATUS line is separate from the JSON response.
"""
from __future__ import annotations

import os
import re
import sys
import urllib.error
import urllib.request

URL = "https://sijiatlas.com/v1/agent/world/overview"


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def main() -> int:
    sys.stdout.reconfigure(encoding="utf-8")
    key = os.environ.get("SIJI_API_KEY", "")
    idem = os.environ.get("SIJI_IDEMPOTENCY_KEY", "my-first-world-overview-001")
    if not re.fullmatch(r"[A-Za-z0-9_.-]{16,512}", key) or not re.fullmatch(
        r"[A-Za-z0-9_.-]{1,128}", idem
    ):
        print("Missing or invalid SIJI_API_KEY / SIJI_IDEMPOTENCY_KEY.", file=sys.stderr)
        return 2
    request = urllib.request.Request(
        URL,
        data=b"{}",
        headers={
            "X-API-Key": key,
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Idempotency-Key": idem,
        },
        method="POST",
    )
    opener = urllib.request.build_opener(urllib.request.ProxyHandler({}), NoRedirect())
    try:
        try:
            response = opener.open(request, timeout=35)
        except urllib.error.HTTPError as error:
            response = error
        with response:
            status = response.code
            raw = response.read(1024 * 1024 + 1)
        if len(raw) > 1024 * 1024:
            print("Response exceeds this example's 1 MiB bound.", file=sys.stderr)
            return 2
        sys.stdout.write(raw.decode("utf-8") + "\nSIJI_HTTP_STATUS=" + str(status) + "\n")
        return 0 if status == 200 else 1
    except (OSError, UnicodeError):
        print("Request outcome unknown; retain the same idempotency key.", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
