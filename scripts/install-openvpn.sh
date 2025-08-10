#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Installing OpenVPN..."

install_package openvpn easy-rsa

mkdir -p /etc/openvpn

# Basic server.conf template - user should customize certificates & keys
cat >/etc/openvpn/server.conf <<EOF
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
server 10.8.0.0 255.255.255.0
keepalive 10 120
persist-key
persist-tun
status openvpn-status.log
verb 3
EOF

systemctl enable openvpn@server
systemctl restart openvpn@server

log INFO "OpenVPN installed and running."