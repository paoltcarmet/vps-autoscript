#!/usr/bin/env bash

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

log "Checking created config files..."

CONFIG_PATHS=(
  "/etc/xray/config.json"
  "/etc/openvpn/server.conf"
  "/etc/stunnel/stunnel.conf"
  "/etc/dropbear/dropbear.conf"
  "/etc/haproxy/haproxy.cfg"
  "/etc/nginx/nginx.conf"
)

for path in "${CONFIG_PATHS[@]}"; do
  if [[ -f "$path" ]]; then
    log "Found config: $path"
  else
    log "Missing config: $path"
  fi
done