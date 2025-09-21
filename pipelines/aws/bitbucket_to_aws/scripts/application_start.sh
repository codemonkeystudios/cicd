#!/usr/bin/env bash
set -euo pipefail
SERVICE_NAME="your-app"
systemctl enable "${SERVICE_NAME}" || true
systemctl restart "${SERVICE_NAME}"
systemctl --no-pager --full status "${SERVICE_NAME}" || true
if ! systemctl is-active --quiet "${SERVICE_NAME}"; then
  echo "[ApplicationStart] ERROR: ${SERVICE_NAME} failed to start."
  exit 1
fi
echo "[ApplicationStart] ${SERVICE_NAME} is running."
