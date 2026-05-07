#!/usr/bin/env bash
set -euo pipefail

# Run as root

SERVER_PUBLIC_IP="YOUR_SERVER_IP"
WG_PORT="51820"
WG_INTERFACE="wg0"
WG_ADDR="10.10.0.1/24"

apt-get update
apt-get install -y wireguard

umask 077

wg genkey | tee /etc/wireguard/server.key | wg pubkey > /etc/wireguard/server.pub

SERVER_PRIVATE_KEY="$(cat /etc/wireguard/server.key)"

cat > "/etc/wireguard/${WG_INTERFACE}.conf" <<EOF
[Interface]
Address = ${WG_ADDR}
ListenPort = ${WG_PORT}
PrivateKey = ${SERVER_PRIVATE_KEY}
SaveConfig = true

PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
EOF

sysctl -w net.ipv4.ip_forward=1

systemctl enable "wg-quick@${WG_INTERFACE}"
systemctl start "wg-quick@${WG_INTERFACE}"

echo "WireGuard running on ${SERVER_PUBLIC_IP}:${WG_PORT}"
echo "Interface: ${WG_INTERFACE}"