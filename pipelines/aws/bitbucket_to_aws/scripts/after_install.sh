#!/usr/bin/env bash
set -euo pipefail
APP_DIR="/var/www/your-app"
RUNTIME_USER="ec2-user"
echo "[AfterInstall] Setting ownership on ${APP_DIR}…"
chown -R "${RUNTIME_USER}:${RUNTIME_USER}" "${APP_DIR}" || true
# Example: Node build
# if [ -f "${APP_DIR}/package.json" ]; then
#   su - "${RUNTIME_USER}" -c "cd ${APP_DIR} && npm ci --no-audit --no-fund"
# fi
