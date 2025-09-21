#!/usr/bin/env bash
set -euo pipefail
SERVICE_NAME="your-app"
echo "[ApplicationStop] Stopping ${SERVICE_NAME} if running…"
if systemctl is-active --quiet "${SERVICE_NAME}"; then
  systemctl stop "${SERVICE_NAME}"
  echo "[ApplicationStop] ${SERVICE_NAME} stopped."
else
  echo "[ApplicationStop] ${SERVICE_NAME} is not running; nothing to stop."
fi
