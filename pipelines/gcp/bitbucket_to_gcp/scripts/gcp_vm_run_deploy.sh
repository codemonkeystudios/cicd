#!/usr/bin/env bash
set -euo pipefail
BUNDLE_ROOT="/tmp/deploy/extracted"
: "${APP_DIR:?APP_DIR must be set}"
[ -x "${BUNDLE_ROOT}/scripts/application_stop.sh" ] && "${BUNDLE_ROOT}/scripts/application_stop.sh"
[ -x "${BUNDLE_ROOT}/scripts/before_install.sh" ] && "${BUNDLE_ROOT}/scripts/before_install.sh"
mkdir -p "${APP_DIR}"
rsync -a --delete "${BUNDLE_ROOT}/app/" "${APP_DIR}/"
[ -x "${BUNDLE_ROOT}/scripts/after_install.sh" ] && "${BUNDLE_ROOT}/scripts/after_install.sh"
[ -x "${BUNDLE_ROOT}/scripts/application_start.sh" ] && "${BUNDLE_ROOT}/scripts/application_start.sh"
[ -x "${BUNDLE_ROOT}/scripts/validate_service.sh" ] && "${BUNDLE_ROOT}/scripts/validate_service.sh"
