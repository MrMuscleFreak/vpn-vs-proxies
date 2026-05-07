# Phase 1 Report: VPNs vs Proxies (Speed and Privacy)

## Abstract

This project compares VPNs and proxies in terms of speed and privacy using a controlled, self-hosted test environment. The goal is to observe how each technology changes the network path, what information remains visible to the outside network, and how much performance overhead each one introduces. A VPN server and a proxy server will be configured manually so the behavior can be studied directly rather than only described in theory. This report documents the scope, environment plan, scripts, and methodology for Phase 1, which establishes the foundation for data collection and analysis in later phases.

## 1. Introduction

VPNs and proxies are widely used to improve privacy and change network paths, yet they operate differently in how they handle data. A VPN typically encrypts all traffic between a client and a VPN server, while a proxy relays traffic without encryption by default and usually only works for the applications configured to use it. These differences can affect both performance and the visibility of traffic on the network. This project focuses on a hands-on setup so those practical trade-offs can be examined in a controlled and repeatable way.

## 2. Objectives

The primary objective is to build a controlled test environment with a self-hosted VPN and a proxy so their impact on speed and privacy can be compared. This phase also aims to demonstrate how network paths change relative to a direct connection, establish a repeatable experiment plan, and define the metrics and tools that will be used in later phases. In addition, Phase 1 prepares the documentation needed to explain the setup clearly in later presentations or reports.

## 3. Scope and Constraints

This phase covers a self-hosted VPN server and a proxy server on Linux, tested with a single Windows client and a single server environment. It includes baseline, proxy, and VPN scenarios, and uses client-side packet capture to confirm what traffic remains visible under each condition. Phase 1 does not include final performance conclusions, large-scale or multi-user testing, production hardening, or any interception of traffic beyond the test client. The purpose of this phase is to define the lab structure and ensure the methods are practical before real measurements are collected.

## 4. Planned Environment

The planned environment uses a Windows laptop as the client and a Kali Linux or Ubuntu VM for the VPN and proxy services, either on the same host or separate hosts. The setup is intentionally simple so the network behavior can be observed without unnecessary complexity. The tools selected for the setup are listed below.

Tools:

- VPN: WireGuard or OpenVPN.
- Proxy: Dante or Squid (SOCKS5 or HTTP proxy).
- Testing: ping, iperf3, web-based speed tests.
- Sniffer: Wireshark.

### Screenshot Placeholders

Insert screenshot of the client machine and network topology here after the environment is prepared.

Insert screenshot of the VPN server terminal or service status here after the VPN is started.

Insert screenshot of the proxy server terminal or service status here after the proxy is started.

## 5. Methodology (Planned)

The baseline test runs with no VPN or proxy to capture default latency and throughput using ping, iperf3, and a web-based speed test. This gives a reference point for later comparisons and helps show what the connection looks like without any tunneling or relaying. The proxy test then enables an authenticated proxy and repeats the same measurements to capture differences in speed and visibility. The VPN test configures a VPN tunnel and routes traffic through it, again repeating the same measurements so the results can be compared fairly. Finally, packet captures on the client are used to compare visibility of DNS, HTTP, and TLS traffic under each condition and to demonstrate the privacy trade-off in a visual way.

### Proxy Script Description

The proxy script installs and configures a minimal authenticated Squid proxy server for lab or testing purposes on Debian or Ubuntu systems. It installs the required Squid and authentication utilities, creates a username and password for proxy access, and writes a simple Squid configuration that listens on port 3128. Access is restricted to users coming from private local network ranges such as 192.168.x.x, 10.x.x.x, and 172.16.x.x, and clients must authenticate with the configured credentials before using the proxy. After configuration, the script enables and restarts the Squid service so the proxy becomes immediately available for testing.

### VPN Script Description

The VPN script installs and configures a minimal WireGuard VPN server on a Debian or Ubuntu-based Linux system for lab or testing purposes. It installs the WireGuard package, generates a server private/public key pair, and creates a basic WireGuard configuration that listens on UDP port 51820 using the wg0 interface. The VPN network uses the internal subnet 10.10.0.0/24, with the server assigned 10.10.0.1. The script also enables IPv4 forwarding and adds a simple NAT rule using iptables so connected VPN clients can access the internet through the server. Finally, it enables and starts the WireGuard interface automatically so the VPN becomes immediately available for testing.

## 6. Metrics and Data Collection

Metrics include average round-trip latency in milliseconds, download and upload throughput in Mbps, and packet visibility indicating whether payloads appear encrypted or readable. Overhead will be calculated as the relative change compared to the baseline results so the effect of each tool can be measured in a consistent way. Each test will be run multiple times to reduce noise, improve repeatability, and make the results easier to defend in a presentation or final report.

## 7. Risks and Mitigations

Internet variability may affect results, so tests will be run at consistent times and repeated to average out spikes. Misconfiguration is addressed by validating routing and IP changes before measurements are recorded, and by checking service status after each script is executed. Ethical constraints are handled by capturing only test client traffic and avoiding any interception of other users' data. This keeps the project focused on a safe lab environment rather than on unauthorized inspection of network traffic.

## 8. Expected Outcomes (Phase 1)

Phase 1 should produce a verified and documented test environment plan, scripts and configuration templates for standing up the VPN and proxy servers, and a clear plan for experiments and data collection in the next phase. It should also provide enough evidence, such as screenshots and service status output, to show that the setup works before any final testing begins.

## 9. References

WireGuard documentation: https://www.wireguard.com/
OpenVPN documentation: https://openvpn.net/community-resources/
SOCKS5 RFC 1928: https://www.rfc-editor.org/rfc/rfc1928
Squid documentation: https://www.squid-cache.org/Doc/
Wireshark user guide: https://www.wireshark.org/docs/wsug_html/
iperf3 documentation: https://iperf.fr/iperf-doc.php
