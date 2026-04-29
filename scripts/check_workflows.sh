#!/usr/bin/env bash
set -euo pipefail

# Validate GitHub Actions workflows with actionlint.
# Falls back to downloading the official binary release when actionlint
# is not already installed on PATH.

if command -v actionlint >/dev/null 2>&1; then
  actionlint -color
  exit 0
fi

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64|amd64) ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *)
    echo "Unsupported architecture for actionlint bootstrap: ${ARCH}" >&2
    exit 2
    ;;
esac

VERSION="1.7.7"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

TARBALL="actionlint_${VERSION#v}_${OS}_${ARCH}.tar.gz"
URL="https://github.com/rhysd/actionlint/releases/download/v${VERSION#v}/${TARBALL}"

curl -fsSL "${URL}" -o "${TMP_DIR}/${TARBALL}"
tar -xzf "${TMP_DIR}/${TARBALL}" -C "${TMP_DIR}"

"${TMP_DIR}/actionlint" -color
