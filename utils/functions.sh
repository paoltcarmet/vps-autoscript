#!/usr/bin/env bash
#
# Common utility functions for VPS setup
#

LOGFILE="/var/log/vps-autosetup.log"

log() {
  local level="$1"
  shift
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOGFILE"
}

install_package() {
  local pkg="$1"
  if ! dpkg -s "$pkg" &>/dev/null; then
    log INFO "Installing package: $pkg"
    apt install -y "$pkg"
  else
    log INFO "Package $pkg is already installed."
  fi
}

restart_service() {
  local svc="$1"
  systemctl daemon-reload
  systemctl enable "$svc"
  systemctl restart "$svc"
  log INFO "Service $svc restarted and enabled."
}

enable_ipv6() {
  sysctl -w net.ipv6.conf.all.disable_ipv6=0
  sysctl -w net.ipv6.conf.default.disable_ipv6=0
  log INFO "IPv6 enabled."
}

disable_ipv6() {
  sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sysctl -w net.ipv6.conf.default.disable_ipv6=1
  log INFO "IPv6 disabled."
}

check_port() {
  local port="$1"
  if ss -tuln | grep -q ":$port "; then
    return 0
  else
    return 1
  fi
}