#!/usr/bin/env bash
# PURPOSE: Post-copy tasks (ownership, deps)
set -euo pipefail
: "${APP_DIR:?APP_DIR must be set by orchestrator}"
RUNTIME_USER="www-data"   # ← change to your runtime user
echo "[AfterInstall] Setting ownership on ${APP_DIR}…"
chown -R "${RUNTIME_USER}:${RUNTIME_USER}" "${APP_DIR}" || true

# Example: Node deps
# if [ -f "${APP_DIR}/package.json" ]; then
#   su - "${RUNTIME_USER}" -c "cd ${APP_DIR} && npm ci --no-audit --no-fund"
# fi
