#!/usr/bin/env bash
# application_start.sh - Start/restart your service
set -euo pipefail
SERVICE_NAME="your-app"  # ← CHANGE
echo "[ApplicationStart] Enabling ${SERVICE_NAME} to start on boot…"
systemctl enable "${SERVICE_NAME}" || true
echo "[ApplicationStart] Restarting ${SERVICE_NAME}…"
systemctl restart "${SERVICE_NAME}"
echo "[ApplicationStart] ${SERVICE_NAME} status (for diagnostics):"
systemctl --no-pager --full status "${SERVICE_NAME}" || true
if ! systemctl is-active --quiet "${SERVICE_NAME}"; then
  echo "[ApplicationStart] ERROR: ${SERVICE_NAME} failed to start."
  exit 1
fi
echo "[ApplicationStart] ${SERVICE_NAME} is running."
