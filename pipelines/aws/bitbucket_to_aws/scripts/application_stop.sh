#!/usr/bin/env bash
set -euo pipefail
SERVICE_NAME="your-app"
echo "[ApplicationStop] Checking if ${SERVICE_NAME} is running…"
if systemctl is-active --quiet "${SERVICE_NAME}"; then
  echo "[ApplicationStop] Stopping ${SERVICE_NAME}…"
  systemctl stop "${SERVICE_NAME}"
  echo "[ApplicationStop] ${SERVICE_NAME} stopped."
else
  echo "[ApplicationStop] ${SERVICE_NAME} is not running; nothing to stop."
fi
