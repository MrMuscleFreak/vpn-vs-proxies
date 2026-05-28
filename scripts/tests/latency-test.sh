#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-1.1.1.1}"
LABEL="${2:-baseline}"
COUNT="${3:-5}"
OUT_FILE="data/raw/latency.csv"

mkdir -p "$(dirname "$OUT_FILE")"

if [ ! -f "$OUT_FILE" ]; then
  echo "timestamp,label,host,avg_ms" > "$OUT_FILE"
fi

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

PING_OUTPUT=$(ping -c "$COUNT" "$HOST" || true)
AVG=$(echo "$PING_OUTPUT" | awk -F'/' '/min\/avg\/max/ {print $5}')

if [ -z "$AVG" ]; then
  AVG="nan"
fi

echo "${TS},${LABEL},${HOST},${AVG}" >> "$OUT_FILE"

echo "Logged latency for $HOST ($LABEL)"
