#!/usr/bin/env bash
set -euo pipefail
HEALTHCHECK_URL="http://127.0.0.1:8080/health"
TIMEOUT_SECONDS=10
set +e
HTTP_STATUS=$(curl -s -o /dev/null -m "${TIMEOUT_SECONDS}" -w "%{http_code}" "${HEALTHCHECK_URL}")
CURL_EXIT=$?
set -e
if [ "${CURL_EXIT}" -ne 0 ]; then exit 1; fi
if [ "${HTTP_STATUS}" -lt 200 ] || [ "${HTTP_STATUS}" -ge 300 ]; then exit 1; fi
