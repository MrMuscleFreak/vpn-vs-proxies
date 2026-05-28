#!/usr/bin/env bash
set -euo pipefail

IFACE="${IFACE:-eth0}"
DURATION_SEC="${DURATION_SEC:-60}"
FILTER="${FILTER:-}"
OUT_DIR="logs/traffic"

mkdir -p "$OUT_DIR"

TS="$(date -u +"%Y%m%dT%H%M%SZ")"
OUT_FILE="${OUT_DIR}/capture_${IFACE}_${TS}.pcap"

CMD=(tcpdump -i "$IFACE" -w "$OUT_FILE")
if [ -n "$FILTER" ]; then
  CMD+=("$FILTER")
fi

echo "Capturing traffic on $IFACE for ${DURATION_SEC}s..."

timeout "$DURATION_SEC" "${CMD[@]}" || true

echo "Saved capture to $OUT_FILE"
