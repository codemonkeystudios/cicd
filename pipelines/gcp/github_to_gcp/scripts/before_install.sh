#!/usr/bin/env bash
set -euo pipefail
: "${APP_DIR:?APP_DIR must be set}"
mkdir -p "${APP_DIR}"
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y || true
  apt-get install -y curl jq unzip rsync || true
else
  yum -y update || true
  yum -y install curl jq unzip rsync || true
fi
