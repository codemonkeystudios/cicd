#!/usr/bin/env bash
set -euo pipefail
BUNDLE_ROOT="/tmp/deploy/extracted"
: "${APP_DIR:?APP_DIR must be set}"
if [ -x "${BUNDLE_ROOT}/scripts/application_stop.sh" ]; then
  "${BUNDLE_ROOT}/scripts/application_stop.sh"
fi
if [ -x "${BUNDLE_ROOT}/scripts/before_install.sh" ]; then
  "${BUNDLE_ROOT}/scripts/before_install.sh"
fi
mkdir -p "${APP_DIR}"
rsync -a --delete "${BUNDLE_ROOT}/app/" "${APP_DIR}/"
if [ -x "${BUNDLE_ROOT}/scripts/after_install.sh" ]; then
  "${BUNDLE_ROOT}/scripts/after_install.sh"
fi
if [ -x "${BUNDLE_ROOT}/scripts/application_start.sh" ]; then
  "${BUNDLE_ROOT}/scripts/application_start.sh"
fi
if [ -x "${BUNDLE_ROOT}/scripts/validate_service.sh" ]; then
  "${BUNDLE_ROOT}/scripts/validate_service.sh"
fi
