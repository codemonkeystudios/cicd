#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# scripts/az_vm_run_deploy.sh — Orchestrate lifecycle ON the Azure VM
# -----------------------------------------------------------------------------
# Order executed:
#   1) application_stop.sh
#   2) before_install.sh
#   3) rsync app/ → $APP_DIR
#   4) after_install.sh
#   5) application_start.sh
#   6) validate_service.sh
# -----------------------------------------------------------------------------
set -euo pipefail
BUNDLE_ROOT="/tmp/deploy/extracted"
: "${APP_DIR:?APP_DIR must be set (e.g., /var/www/your-app)}"

echo "[AZ-DEPLOY] Bundle root: ${BUNDLE_ROOT}"
echo "[AZ-DEPLOY] Target APP_DIR: ${APP_DIR}"

export APP_DIR

if [ -x "${BUNDLE_ROOT}/scripts/application_stop.sh" ]; then
  echo "[AZ-DEPLOY] application_stop.sh"
  "${BUNDLE_ROOT}/scripts/application_stop.sh"
fi

if [ -x "${BUNDLE_ROOT}/scripts/before_install.sh" ]; then
  echo "[AZ-DEPLOY] before_install.sh"
  "${BUNDLE_ROOT}/scripts/before_install.sh"
fi

echo "[AZ-DEPLOY] Syncing app files…"
mkdir -p "${APP_DIR}"
rsync -a --delete "${BUNDLE_ROOT}/app/" "${APP_DIR}/"

if [ -x "${BUNDLE_ROOT}/scripts/after_install.sh" ]; then
  echo "[AZ-DEPLOY] after_install.sh"
  "${BUNDLE_ROOT}/scripts/after_install.sh"
fi

if [ -x "${BUNDLE_ROOT}/scripts/application_start.sh" ]; then
  echo "[AZ-DEPLOY] application_start.sh"
  "${BUNDLE_ROOT}/scripts/application_start.sh"
fi

if [ -x "${BUNDLE_ROOT}/scripts/validate_service.sh" ]; then
  echo "[AZ-DEPLOY] validate_service.sh"
  "${BUNDLE_ROOT}/scripts/validate_service.sh"
fi

echo "[AZ-DEPLOY] Deployment completed."
