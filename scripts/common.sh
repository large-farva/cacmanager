#!/usr/bin/env bash
set -euo pipefail

info()   { echo "[INFO] $*"; }
warn()   { echo "[WARN] $*"; }
error()  { echo "[ERROR] $*" >&2; }

ask_yes_no() {
  read -rp "$1 [y/N]: " response
  [[ "${response,,}" == "y" || "${response,,}" == "yes" ]]
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    error "Missing required command: $1"
    exit 1
  }
}
