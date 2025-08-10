#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Setting up firewall..."

install_package ufw

ufw --force reset
ufw default deny incoming
ufw default allow outgoing

PORTS=(22 80 443 447 777 109 143 7100:7300 81 1194 2200)

for p in "${PORTS[@]}"; do
  ufw allow "$p"
done

ufw enable

log INFO "Firewall configured and enabled."