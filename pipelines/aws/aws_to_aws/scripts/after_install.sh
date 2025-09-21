#!/usr/bin/env bash
# after_install.sh - Post-copy tasks
set -euo pipefail
APP_DIR="/var/www/your-app"  # ← CHANGE: must match appspec.yml destination
RUNTIME_USER="ec2-user"      # ← CHANGE: user that should own/run app
echo "[AfterInstall] Setting ownership on ${APP_DIR} to ${RUNTIME_USER}…"
chown -R "${RUNTIME_USER}:${RUNTIME_USER}" "${APP_DIR}" || true
# Example language‑specific steps (uncomment as needed):
# if [ -f "${APP_DIR}/package.json" ]; then
#   su - "${RUNTIME_USER}" -c "cd ${APP_DIR} && npm ci --no-audit --no-fund"
# fi
