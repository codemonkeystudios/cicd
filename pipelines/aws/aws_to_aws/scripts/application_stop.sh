#!/usr/bin/env bash
# application_stop.sh - Stop your service if running
set -euo pipefail
SERVICE_NAME="your-app"   # ← CHANGE: systemd unit name (e.g., your-app.service)
echo "[ApplicationStop] Stopping ${SERVICE_NAME} if running…"
if systemctl is-active --quiet "${SERVICE_NAME}"; then
  systemctl stop "${SERVICE_NAME}"
  echo "[ApplicationStop] ${SERVICE_NAME} stopped."
else
  echo "[ApplicationStop] ${SERVICE_NAME} not running; nothing to stop."
fi
