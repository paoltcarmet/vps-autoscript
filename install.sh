#!/usr/bin/env bash
#
# Main Installer - Ubuntu 24/25 VPS AutoSetup
#

set -euo pipefail
IFS=$'\n\t'

LOGFILE="/var/log/vps-autosetup.log"

# Function to log messages (both stdout and logfile)
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOGFILE"
}

# Check if run as root
if [[ $EUID -ne 0 ]]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Prepare log file
touch "$LOGFILE"
chmod 600 "$LOGFILE"

log "[INFO] Starting VPS Auto Setup..."

log "[INFO] Updating package lists and upgrading system..."
apt update && apt upgrade -y >> "$LOGFILE" 2>&1

log "[INFO] Installing required dependencies..."
apt install -y curl wget git unzip socat cron iptables whiptail jq tar net-tools dnsutils nano ufw golang-go make rclone vnstat >> "$LOGFILE" 2>&1

# Check and set execute permissions if utils and scripts folders exist
if [[ -d "./utils" ]]; then
  log "[INFO] Setting execute permission for utils scripts..."
  chmod +x ./utils/*.sh
else
  log "[WARN] utils directory not found! Skipping chmod for utils."
fi

if [[ -d "./scripts" ]]; then
  log "[INFO] Setting execute permission for scripts..."
  chmod +x ./scripts/*.sh
else
  log "[WARN] scripts directory not found! Skipping chmod for scripts."
fi

# Run menu
if [[ -f "./utils/menu.sh" ]]; then
  log "[INFO] Starting menu interface..."
  ./utils/menu.sh
else
  log "[ERROR] menu.sh script not found in utils directory!"
  echo "ERROR: menu.sh script not found in utils directory!"
  exit 1
fi
