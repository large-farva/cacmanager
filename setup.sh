#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/scripts" && pwd)"

# Detect distro
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    DISTRO_ID="${ID,,}"
else
    echo "Unable to detect Linux distribution (missing /etc/os-release)"
    exit 1
fi

# Route to the appropriate script
case "$DISTRO_ID" in
    fedora)
        bash "$SCRIPT_DIR/fedora.sh"
        ;;
    *)
        echo "Unsupported distribution: $DISTRO_ID"
        echo "Currently supported: Fedora"
        exit 1
        ;;
esac
