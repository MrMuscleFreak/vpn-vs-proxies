#!/usr/bin/env bash
set -euo pipefail

URL="${1:-https://speed.hetzner.de/100MB.bin}"
LABEL="${2:-baseline}"
PROXY_URL="${3:-}"
OUT_FILE="data/raw/bandwidth.csv"

mkdir -p "$(dirname "$OUT_FILE")"

if [ ! -f "$OUT_FILE" ]; then
  echo "timestamp,label,url,proxy_used,bytes_downloaded,speed_download,time_total" > "$OUT_FILE"
fi

CURL_PROXY=()
if [ -n "$PROXY_URL" ]; then
  CURL_PROXY=(--proxy "$PROXY_URL")
fi

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

METRICS=$(curl -sS -o /dev/null -w "%{size_download},%{speed_download},%{time_total}" "${CURL_PROXY[@]}" "$URL")

PROXY_USED="no"
if [ -n "$PROXY_URL" ]; then
  PROXY_USED="yes"
fi

echo "${TS},${LABEL},${URL},${PROXY_USED},${METRICS}" >> "$OUT_FILE"

echo "Logged bandwidth for $URL ($LABEL)"
