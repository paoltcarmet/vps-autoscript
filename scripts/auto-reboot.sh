#!/usr/bin/env bash
source ../utils/functions.sh

REBOOT_TIME="5:00"

log INFO "Setting up automatic daily reboot at $REBOOT_TIME..."

CRON_JOB="0 5 * * * /sbin/shutdown -r now"

(crontab -l 2>/dev/null | grep -Fv "$CRON_JOB"; echo "$CRON_JOB") | crontab -

log INFO "Auto reboot cron job installed to run daily at 5 AM."