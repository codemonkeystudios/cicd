#!/usr/bin/env bash
# PURPOSE: Stop the app if running
set -euo pipefail
SERVICE_NAME="your-app"   # ← change to your systemd unit
echo "[ApplicationStop] Stopping ${SERVICE_NAME} if running…"
if systemctl is-active --quiet "${SERVICE_NAME}"; then
  systemctl stop "${SERVICE_NAME}"
  echo "[ApplicationStop] ${SERVICE_NAME} stopped."
else
  echo "[ApplicationStop] ${SERVICE_NAME} not running; nothing to stop."
fi
