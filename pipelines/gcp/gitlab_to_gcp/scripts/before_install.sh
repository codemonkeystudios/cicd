#!/usr/bin/env bash
# PURPOSE: Prepare instance (directories, base packages)
set -euo pipefail
: "${APP_DIR:?APP_DIR must be set by orchestrator}"

echo "[BeforeInstall] Ensuring target directory exists: ${APP_DIR}"
mkdir -p "${APP_DIR}"

if command -v apt-get >/dev/null 2>&1; then
  echo "[BeforeInstall] Installing packages via apt-get…"
  apt-get update -y || true
  apt-get install -y curl jq unzip rsync || true
else
  echo "[BeforeInstall] Installing packages via yum…"
  yum -y update || true
  yum -y install curl jq unzip rsync || true
fi
