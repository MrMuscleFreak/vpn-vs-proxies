#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="logs"

mkdir -p "$OUT_DIR"

TS="$(date -u +"%Y%m%dT%H%M%SZ")"
OUT_FILE="${OUT_DIR}/conn_stats_${TS}.txt"

{
  echo "Timestamp: $TS"
  echo "---- ss -s ----"
  ss -s
  echo "---- ss -tunap ----"
  ss -tunap
} > "$OUT_FILE"

echo "Saved connection stats to $OUT_FILE"
