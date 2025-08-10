#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Checking bandwidth usage with vnStat..."

if ! command -v vnstat &>/dev/null; then
  install_package vnstat
fi

vnstat -d