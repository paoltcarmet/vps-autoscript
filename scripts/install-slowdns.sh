#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Installing SlowDNS server..."

install_package golang-go make git

cd /opt || exit
if [[ ! -d slowdns ]]; then
  git clone https://github.com/HyNetwork/slowdns.git
fi
cd slowdns || exit
make

if [[ ! -f server.key ]]; then
  ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
fi

cat >/etc/systemd/system/slowdns-server.service <<EOF
[Unit]
Description=SlowDNS Server
After=network.target

[Service]
ExecStart=/opt/slowdns/dnstt-server -udp :5300 -privkey-file /opt/slowdns/server.key example.com
Restart=always

[Install]
WantedBy=multi-user.target
EOF

restart_service slowdns-server
log INFO "SlowDNS installed and running."