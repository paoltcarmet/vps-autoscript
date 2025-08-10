#!/usr/bin/env bash
#
# Main Installer - Ubuntu 24/25 VPS AutoSetup
#

set -euo pipefail
IFS=$'\n\t'

if [[ $EUID -ne 0 ]]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

echo "[INFO] Updating system..."
apt update && apt upgrade -y

echo "[INFO] Installing required dependencies..."
apt install -y curl wget git unzip socat cron iptables whiptail jq tar net-tools dnsutils nano ufw golang-go make rclone vnstat

# Make sure utils and scripts are executable
chmod +x ./utils/*.sh
chmod +x ./scripts/*.sh

echo "[INFO] Starting menu..."
./utils/menu.sh