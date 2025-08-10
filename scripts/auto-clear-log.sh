#!/usr/bin/env bash
source ../utils/functions.sh

LOG_DIR="/var/log"
RETENTION_DAYS=7

log INFO "Setting up automatic log clearing for files older than $RETENTION_DAYS days in $LOG_DIR..."

# Create cron job if not exists
CRON_JOB="0 3 * * * find $LOG_DIR -type f -name '*.log' -mtime +$RETENTION_DAYS -exec rm -f {} \;"

(crontab -l 2>/dev/null | grep -Fv "$CRON_JOB"; echo "$CRON_JOB") | crontab -

log INFO "Auto-clear log cron job installed to run daily at 3AM."