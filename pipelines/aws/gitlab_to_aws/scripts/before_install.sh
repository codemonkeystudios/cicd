#!/usr/bin/env bash
set -euo pipefail
TARGET_DIR="/var/www/your-app"
echo "[BeforeInstall] Ensuring target directory exists: ${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"
if command -v yum >/dev/null 2>&1; then
  yum -y update || true
  yum -y install curl jq unzip rsync || true
elif command -v apt-get >/dev/null 2>&1; then
  apt-get update -y || true
  apt-get install -y curl jq unzip rsync || true
fi
