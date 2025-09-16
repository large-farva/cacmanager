#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

info "Starting CAC setup for Fedora..."

# Certificate source
CERTS_URL="https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/unclass-certificates_pkcs7_v5-6_dod.zip"
CAC_DIR="$HOME/.cac"
CERTS_DIR="$CAC_DIR/certs"
mkdir -p "$CERTS_DIR"

# Required packages
REQUIRED_PKGS=(
  pcsc-lite
  pcsc-lite-ccid
  opensc
  p11-kit
  p11-kit-trust
  nss-tools
  ca-certificates
  unzip
  openssl
  curl
  pcsc-tools
)

info "Checking required commands..."
need_cmd curl
need_cmd openssl
need_cmd unzip
need_cmd dnf
need_cmd systemctl
need_cmd trust

info "Installing required packages..."
sudo dnf install -y "${REQUIRED_PKGS[@]}"

info "Enabling smartcard service..."
sudo systemctl enable --now pcscd.socket

info "Downloading DoD certificate bundle..."
ZIP_PATH="$CERTS_DIR/certs.zip"
curl -fsSL "$CERTS_URL" -o "$ZIP_PATH"

info "Extracting certificate bundle..."
unzip -o -q "$ZIP_PATH" -d "$CERTS_DIR"

P7B_FILE=$(find "$CERTS_DIR" -iname '*.p7b' -o -iname '*.p7c' | head -n 1 || true)
if [[ -z "$P7B_FILE" ]]; then
  error "No PKCS#7 (.p7b/.p7c) file found in extracted bundle."
  exit 1
fi

PEM_FILE="$CERTS_DIR/certs.pem"
info "Converting PKCS#7 to PEM..."
openssl pkcs7 -print_certs -in "$P7B_FILE" -out "$PEM_FILE"

info "Installing DoD certificates into trust store..."
sudo trust anchor --remove "$CERTS_DIR"/*.pem 2>/dev/null || true
sudo trust anchor "$CERTS_DIR"/*.pem
sudo update-ca-trust extract

info "Running smartcard diagnostic (3s)..."
timeout 3s pcsc_scan || true

info "CAC setup complete."
echo ""
echo "✅ CAC support is now configured for Firefox (only)."
echo ""
echo "You can test it by:"
echo "  1) Insert your CAC card"
echo "  2) Run:  pcsc_scan     (check that the card is detected)"
echo "  3) Open Firefox (RPM version preferred, not Flatpak)"
echo "  4) Visit a CAC-protected website (e.g., a DoD portal)"
echo ""
echo "⚠️ Chromium/Chrome are not currently supported by this script."
