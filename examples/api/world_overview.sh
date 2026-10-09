#!/bin/sh
# POSIX shell + cURL (macOS / Linux). No files, redirect or automatic retry.
# Supply SIJI_API_KEY privately; reuse SIJI_IDEMPOTENCY_KEY for this exact request.
set +x
set -eu
: "${SIJI_API_KEY:?Set SIJI_API_KEY privately in this process environment}"
SIJI_IDEMPOTENCY_KEY=${SIJI_IDEMPOTENCY_KEY:-my-first-world-overview-001}
case "$SIJI_API_KEY" in *[!A-Za-z0-9_.-]*|'') exit 2 ;; esac
case "$SIJI_IDEMPOTENCY_KEY" in *[!A-Za-z0-9_.-]*|'') exit 2 ;; esac
[ "${#SIJI_API_KEY}" -ge 16 ] && [ "${#SIJI_API_KEY}" -le 512 ] || exit 2
[ "${#SIJI_IDEMPOTENCY_KEY}" -le 128 ] || exit 2
# Header secrets go through a private pipe, not cURL's argument list or a file.
printf 'header = "X-API-Key: %s"\nheader = "Idempotency-Key: %s"\n' \
    "$SIJI_API_KEY" "$SIJI_IDEMPOTENCY_KEY" |
    curl --disable --config - --silent --show-error --fail-with-body \
        --proto '=https' --noproxy '*' --connect-timeout 10 --max-time 35 \
        --max-filesize 1048576 --retry 0 --request POST \
        --header 'Content-Type: application/json' --header 'Accept: application/json' \
        --data '{}' --write-out '\nSIJI_HTTP_STATUS=%{http_code}\n' \
        'https://sijiatlas.com/v1/agent/world/overview'
