#!/usr/bin/env bash
set -euo pipefail

URL="${1:-}"
LABEL="${2:-baseline}"
PROXY_URL="${3:-}"
OUT_FILE="data/raw/http-timing.csv"

if [ -z "$URL" ]; then
  echo "Usage: $0 <url> [label] [proxy_url]"
  exit 1
fi

mkdir -p "$(dirname "$OUT_FILE")"

if [ ! -f "$OUT_FILE" ]; then
  echo "timestamp,label,url,proxy_used,time_namelookup,time_connect,time_appconnect,time_starttransfer,time_total,speed_download" > "$OUT_FILE"
fi

CURL_PROXY=()
if [ -n "$PROXY_URL" ]; then
  CURL_PROXY=(--proxy "$PROXY_URL")
fi

TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

METRICS=$(curl -sS -o /dev/null -w "%{time_namelookup},%{time_connect},%{time_appconnect},%{time_starttransfer},%{time_total},%{speed_download}" "${CURL_PROXY[@]}" "$URL")

PROXY_USED="no"
if [ -n "$PROXY_URL" ]; then
  PROXY_USED="yes"
fi

echo "${TS},${LABEL},${URL},${PROXY_USED},${METRICS}" >> "$OUT_FILE"

echo "Logged timing for $URL ($LABEL)"
