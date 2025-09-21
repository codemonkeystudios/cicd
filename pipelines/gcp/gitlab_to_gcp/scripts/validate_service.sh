#!/usr/bin/env bash
# PURPOSE: Health probe
set -euo pipefail
HEALTHCHECK_URL="http://127.0.0.1:8080/health"  # change to your app
TIMEOUT_SECONDS=10
echo "[ValidateService] Probing ${HEALTHCHECK_URL}…"
set +e
HTTP_STATUS=$(curl -s -o /dev/null -m "${TIMEOUT_SECONDS}" -w "%{http_code}" "${HEALTHCHECK_URL}")
CURL_EXIT=$?
set -e
if [ "${CURL_EXIT}" -ne 0 ]; then
  echo "[ValidateService] ERROR: curl failed with exit code ${CURL_EXIT}."
  exit 1
fi
if [ "${HTTP_STATUS}" -ge 200 ] && [ "${HTTP_STATUS}" -lt 300 ]; then
  echo "[ValidateService] Success: HTTP ${HTTP_STATUS}."
  exit 0
else
  echo "[ValidateService] ERROR: Unhealthy HTTP status ${HTTP_STATUS}."
  exit 1
fi
