#!/usr/bin/env bash
set -euo pipefail
: "${APP_DIR:?APP_DIR must be set}"
RUNTIME_USER="www-data"
chown -R "${RUNTIME_USER}:${RUNTIME_USER}" "${APP_DIR}" || true
