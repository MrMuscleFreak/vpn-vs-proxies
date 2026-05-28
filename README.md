# VPNs vs Proxies: Testing and Measurement

This project compares VPNs and proxies in a real networking setup. It includes server setup scripts, client-side test scripts, traffic capture helpers, and a step-by-step testing plan.

## Folder structure

- docs/ Supporting notes and the project abstract.
- scripts/ Server setup, monitoring, tests, and analysis.
- data/raw/ Raw CSV outputs from test runs.
- data/processed/ Aggregated summaries.
- logs/ Traffic captures and connection snapshots.
- results/figures/ Optional graphs you generate.

## Prerequisites

On the Linux test client (or VM):

- curl, iproute2, iputils-ping, tcpdump, coreutils
- Optional: wireshark or tshark to inspect .pcap files

Use the helper to install missing tools:

```bash
sudo scripts/utils/ensure-tools.sh
```

## Server setup

### VPN server (WireGuard)

On the VPN server:

```bash
sudo scripts/vpn-server-wireguard.sh
```

You will still need a client config. Create a client peer on the server and use a standard WireGuard client on your test machine.

### Proxy server (Squid HTTP)

On the proxy server:

```bash
sudo scripts/proxy-server-squid-http.sh
```

Use the IP, port, and credentials it prints to configure your client tests.

## Client test workflow

1. Baseline (no VPN, no proxy)

```bash
MODE=baseline RUNS=5 scripts/tests/run-suite.sh
```

2. VPN test

- Connect your client to the VPN first.

```bash
MODE=vpn RUNS=5 scripts/tests/run-suite.sh
```

3. Proxy test

- Use the proxy URL format: http://user:pass@proxy_ip:3128

```bash
MODE=proxy PROXY_URL="http://user:pass@proxy_ip:3128" RUNS=5 scripts/tests/run-suite.sh
```

All results land in data/raw/ as CSV files.

## Traffic capture

Capture traffic while a test suite runs:

```bash
sudo IFACE=eth0 DURATION_SEC=60 scripts/monitoring/capture-traffic.sh
```

This writes a .pcap file to logs/traffic/. Open it in Wireshark and compare:

- Baseline: full HTTP details visible
- Proxy: HTTP visible to proxy, destination still visible
- VPN: tunneled traffic, payload hidden

## Analyze and summarize

After running baseline, VPN, and proxy suites:

```bash
scripts/analysis/summarize-results.sh
```

This generates a quick summary in data/processed/summary.txt.

## Recommended testing plan

- Run 5-10 repetitions per mode to reduce noise.
- Use the same URLs and targets across all runs.
- Capture at least one traffic sample for each mode.
- Record environment details (server location, client OS, time of day).
- Present both speed and privacy observations.

## Notes

- Proxies do not encrypt payloads by default; HTTPS is still encrypted end-to-end, but the proxy can see destination and metadata.
- VPNs tunnel traffic, which adds overhead but hides internal payloads from intermediate observers.
