#!/usr/bin/env bash
set -euo pipefail

WG_IF="wg0"
WG_ADDR="10.10.0.1/24"
WG_PORT="51820"
CLIENT_IP="10.10.0.2"

apt update
apt install -y wireguard iptables

sysctl -w net.ipv4.ip_forward=1

umask 077
wg genkey | tee /etc/wireguard/server.key | wg pubkey > /etc/wireguard/server.pub

SERVER_PRIV=$(cat /etc/wireguard/server.key)
SERVER_PUB=$(cat /etc/wireguard/server.pub)

EXT_IF=$(ip route | awk '/default/ {print $5}')

cat > /etc/wireguard/${WG_IF}.conf <<EOF
[Interface]
Address = ${WG_ADDR}
ListenPort = ${WG_PORT}
PrivateKey = ${SERVER_PRIV}

PostUp = iptables -A FORWARD -i ${WG_IF} -j ACCEPT; iptables -A FORWARD -o ${WG_IF} -j ACCEPT; iptables -t nat -A POSTROUTING -o ${EXT_IF} -j MASQUERADE
PostDown = iptables -D FORWARD -i ${WG_IF} -j ACCEPT; iptables -D FORWARD -o ${WG_IF} -j ACCEPT; iptables -t nat -D POSTROUTING -o ${EXT_IF} -j MASQUERADE

[Peer]
PublicKey = 23Xm8Tajd+/Ao1LbC5M9Nk94fPphJYwNNU/gJX5Ivhs=
AllowedIPs = ${CLIENT_IP}/32
EOF

systemctl enable wg-quick@${WG_IF}
systemctl restart wg-quick@${WG_IF}