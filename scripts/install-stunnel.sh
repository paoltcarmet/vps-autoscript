#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Installing Stunnel5..."

install_package stunnel4 openssl

cat >/etc/stunnel/stunnel.conf <<EOF
cert = /etc/stunnel/stunnel.pem
client = no

[dropbear]
accept = 447
connect = 109

[openvpn]
accept = 777
connect = 1194
EOF

if [[ ! -f /etc/stunnel/stunnel.pem ]]; then
  openssl req -new -x509 -days 3650 -nodes -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem \
    -subj "/C=US/ST=State/L=City/O=Org/OU=IT/CN=example.com"
fi

systemctl enable stunnel4
systemctl restart stunnel4

log INFO "Stunnel installed and service started."