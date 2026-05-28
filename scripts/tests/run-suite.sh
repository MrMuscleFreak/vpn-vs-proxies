#!/usr/bin/env bash
set -euo pipefail

MODE="${MODE:-baseline}"
RUNS="${RUNS:-3}"
TARGET_URL="${TARGET_URL:-https://example.com}"
DOWNLOAD_URL="${DOWNLOAD_URL:-https://speed.hetzner.de/100MB.bin}"
PING_HOST="${PING_HOST:-1.1.1.1}"
PROXY_URL="${PROXY_URL:-}"

if [ "$MODE" = "proxy" ] && [ -z "$PROXY_URL" ]; then
  echo "MODE=proxy requires PROXY_URL"
  exit 1
fi

LABEL="$MODE"

for i in $(seq 1 "$RUNS"); do
  echo "Run $i/$RUNS ($MODE)"
  scripts/tests/http-timing.sh "$TARGET_URL" "$LABEL" "$PROXY_URL"
  scripts/tests/bandwidth-test.sh "$DOWNLOAD_URL" "$LABEL" "$PROXY_URL"
  scripts/tests/latency-test.sh "$PING_HOST" "$LABEL" 5
  echo "---"
  sleep 2
done

echo "Completed test suite for $MODE"
