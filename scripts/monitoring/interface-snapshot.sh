#!/usr/bin/env bash
set -euo pipefail

IFACE="${IFACE:-eth0}"
OUT_DIR="logs"

mkdir -p "$OUT_DIR"

TS="$(date -u +"%Y%m%dT%H%M%SZ")"
OUT_FILE="${OUT_DIR}/iface_${IFACE}_${TS}.txt"

ip -s link show "$IFACE" > "$OUT_FILE"

echo "Saved interface snapshot to $OUT_FILE"
