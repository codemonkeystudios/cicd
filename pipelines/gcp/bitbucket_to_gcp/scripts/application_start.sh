#!/usr/bin/env bash
set -euo pipefail
SERVICE_NAME="your-app"
systemctl enable "${SERVICE_NAME}" || true
systemctl restart "${SERVICE_NAME}"
if ! systemctl is-active --quiet "${SERVICE_NAME}"; then
  echo "Service failed to start" >&2
  exit 1
fi
