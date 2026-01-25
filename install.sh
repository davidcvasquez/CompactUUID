#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# install.sh — install compactuuid + man page on macOS
#
# Installs:
#   /usr/local/bin/compactuuid
#   /usr/local/share/man/man1/compactuuid.1
#
# Run:
#   ./install.sh
#
# Notes:
# - Requires sudo for /usr/local paths on many systems.
# - Assumes this script is located at the Swift package root.
# ------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# What the intalled command should be named:
INSTALL_BIN_NAME="compactuuid"

# The SwiftPM executable *target* name
EXEC_TARGET_NAME="CompactUUIDCLI"

MAN_NAME="compactuuid.1"

DEST_BIN_DIR="/usr/local/bin"
DEST_MAN_DIR="/usr/local/share/man/man1"

SRC_MAN_PATH="ManPages/${MAN_NAME}"

echo "==> Building release binary target: ${EXEC_TARGET_NAME} ..."
swift build -c release --target "${EXEC_TARGET_NAME}"

# SwiftPM outputs the binary named after the target.
SRC_BIN_PATH=".build/release/${EXEC_TARGET_NAME}"

#SwiftPM outputs the binary named after the target.
SRC_BIN_PATH=".build/release/${EXEC_TARGET_NAME}"

if [[ ! -f "$SRC_BIN_PATH" ]]; then
  echo "ERROR: Expected binary not found at: $SRC_BIN_PATH"
  exit 1
fi

if [[ ! -f "$SRC_MAN_PATH" ]]; then
  echo "ERROR: Expected man page not found at: $SRC_MAN_PATH"
  exit 1
fi

echo "==> Installing binary to ${DEST_BIN_DIR}/${INSTALL_BIN_NAME}"
sudo mkdir -p "$DEST_BIN_DIR"
sudo install -m 0755 "$SRC_BIN_PATH" "$DEST_BIN_DIR/$INSTALL_BIN_NAME"

echo "==> Installing man page to ${DEST_MAN_DIR}/${MAN_NAME}"
sudo mkdir -p "$DEST_MAN_DIR"
sudo install -m 0644 "$SRC_MAN_PATH" "$DEST_MAN_DIR/$MAN_NAME"

echo "==> Done."
echo
echo "Try:"
echo "  ${INSTALL_BIN_NAME} --help"
echo "  man ${INSTALL_BIN_NAME}"
