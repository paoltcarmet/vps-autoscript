#!/usr/bin/env bash
source "$(dirname "$0")/functions.sh"

while true; do
  CHOICE=$(whiptail --title "VPS AutoSetup Menu" --menu "Select an option:" 25 70 20 \
    "1" "Setup Firewall & IPtables" \
    "2" "Install XRAY (Vmess/Vless/Trojan WS/gRPC)" \
    "3" "Install OpenVPN" \
    "4" "Install SlowDNS (DNS Tunnel)" \
    "5" "Install Dropbear" \
    "6" "Install Stunnel5" \
    "7" "Install HAProxy Load Balancer" \
    "8" "Install Nginx Webserver" \
    "9" "Enable BBRPlus Kernel" \
    "10" "Change DNS Servers" \
    "11" "Netflix Region Checker" \
    "12" "Change XRAY Core" \
    "13" "Setup Virtual Swap RAM" \
    "14" "Bandwidth Monitor" \
    "15" "RAM Monitor" \
    "16" "Check Login Users" \
    "17" "Check Created Config Files" \
    "18" "Auto Clear Log Setup" \
    "19" "Auto Reboot Setup" \
    "20" "Backup & Restore" \
    "0" "Exit" 3>&1 1>&2 2>&3)

  case "$CHOICE" in
    1) bash ../scripts/firewall-setup.sh ;;
    2) bash ../scripts/install-xray.sh ;;
    3) bash ../scripts/install-openvpn.sh ;;
    4) bash ../scripts/install-slowdns.sh ;;
    5) bash ../scripts/install-dropbear.sh ;;
    6) bash ../scripts/install-stunnel.sh ;;
    7) bash ../scripts/install-haproxy.sh ;;
    8) bash ../scripts/install-nginx.sh ;;
    9) bash ../scripts/enable-bbrplus.sh ;;
    10) bash ../scripts/dns-changer.sh ;;
    11) bash ../scripts/netflix-checker.sh ;;
    12) bash ../scripts/xraycore-changer.sh ;;
    13) bash ../scripts/swap-setup.sh ;;
    14) bash ../scripts/bandwidth-monitor.sh ;;
    15) bash ../scripts/ram-monitor.sh ;;
    16) bash ../scripts/check-login-user.sh ;;
    17) bash ../scripts/check-created-config.sh ;;
    18) bash ../scripts/auto-clear-log.sh ;;
    19) bash ../scripts/auto-reboot.sh ;;
    20) bash ../scripts/backup-restore.sh ;;
    0) exit 0 ;;
  esac
done