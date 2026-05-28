#!/usr/bin/env bash
set -euo pipefail

# Run as root to install missing packages

MISSING=()

for cmd in curl ip ping tcpdump ss timeout awk; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    MISSING+=("$cmd")
  fi
done

if [ ${#MISSING[@]} -eq 0 ]; then
  echo "All required tools are already installed."
  exit 0
fi

echo "Installing missing tools: ${MISSING[*]}"

apt-get update
apt-get install -y curl iproute2 iputils-ping tcpdump coreutils gawk

echo "Done."
