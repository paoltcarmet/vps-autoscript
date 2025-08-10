#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Change system DNS servers..."

DNS_SERVERS=$(whiptail --title "DNS Changer" --inputbox "Enter DNS servers separated by space (e.g. 1.1.1.1 8.8.8.8):" 10 60 3>&1 1>&2 2>&3)

if [[ -z "$DNS_SERVERS" ]]; then
  log INFO "No DNS servers entered. Abort."
  exit 1
fi

cp /etc/resolv.conf /etc/resolv.conf.bak

echo "" > /etc/resolv.conf
for dns in $DNS_SERVERS; do
  echo "nameserver $dns" >> /etc/resolv.conf
done

log INFO "DNS changed to: $DNS_SERVERS"