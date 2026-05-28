#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="data/processed"
OUT_FILE="${OUT_DIR}/summary.txt"

mkdir -p "$OUT_DIR"

{
  echo "Summary generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo ""

  if [ -f data/raw/http-timing.csv ]; then
    echo "HTTP timing (avg time_total by label):"
    awk -F',' 'NR>1 {sum[$2]+=$9; cnt[$2]++} END {for (l in sum) printf "  %s: %.3f s\n", l, sum[l]/cnt[l]}' data/raw/http-timing.csv
    echo ""
  fi

  if [ -f data/raw/bandwidth.csv ]; then
    echo "Bandwidth (avg speed_download bytes/sec by label):"
    awk -F',' 'NR>1 {sum[$2]+=$6; cnt[$2]++} END {for (l in sum) printf "  %s: %.1f\n", l, sum[l]/cnt[l]}' data/raw/bandwidth.csv
    echo ""
  fi

  if [ -f data/raw/latency.csv ]; then
    echo "Latency (avg ms by label):"
    awk -F',' 'NR>1 && $4 != "nan" {sum[$2]+=$4; cnt[$2]++} END {for (l in sum) printf "  %s: %.2f ms\n", l, sum[l]/cnt[l]}' data/raw/latency.csv
    echo ""
  fi
} > "$OUT_FILE"

echo "Wrote summary to $OUT_FILE"
