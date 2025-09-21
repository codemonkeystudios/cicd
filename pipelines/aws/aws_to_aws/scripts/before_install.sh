#!/usr/bin/env bash
# before_install.sh - Prepare instance BEFORE files are copied
set -euo pipefail
TARGET_DIR="/var/www/your-app"  # ← CHANGE: must match appspec.yml destination
echo "[BeforeInstall] Ensuring ${TARGET_DIR} exists…"
mkdir -p "${TARGET_DIR}"
echo "[BeforeInstall] Installing base packages (non-fatal on failure)…"
if command -v yum >/dev/null 2>&1; then
  yum -y update || true
  yum -y install curl jq unzip rsync || true
elif command -v apt-get >/dev/null 2>&1; then
  apt-get update -y || true
  apt-get install -y curl jq unzip rsync || true
fi
