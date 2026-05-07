#!/usr/bin/env bash
set -euo pipefail

# Run as root

PROXY_PORT="3128"
PROXY_USER="testuser"
PROXY_PASS="testpass"

apt-get update
apt-get install -y squid apache2-utils

htpasswd -b -c /etc/squid/passwd "${PROXY_USER}" "${PROXY_PASS}"

cat > /etc/squid/squid.conf <<EOF
http_port ${PROXY_PORT}

auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm Proxy
acl authenticated proxy_auth REQUIRED

acl localnet src 10.0.0.0/8
acl localnet src 127.0.0.1/32
acl localnet src 192.168.0.0/16

acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 443
acl CONNECT method CONNECT

http_access allow localhost
http_access allow localnet
http_access deny all
EOF

systemctl enable squid
systemctl restart squid

echo "Proxy running on port ${PROXY_PORT}"
echo "Login: ${PROXY_USER} / ${PROXY_PASS}"
