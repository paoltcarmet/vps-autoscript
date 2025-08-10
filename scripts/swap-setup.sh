#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Setting up virtual swap RAM..."

if free | awk '/^Swap:/ {exit !$2}'; then
  log INFO "Swap is already enabled."
else
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
  log INFO "2GB swap file created and enabled."
fi