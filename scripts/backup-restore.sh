#!/usr/bin/env bash
source ../utils/functions.sh

BACKUP_DIR="/root/vps-backups"
REMOTE_RCLONE_REMOTE="your-remote:"   # Change to your rclone remote name

function backup_data() {
  mkdir -p "$BACKUP_DIR"

  log INFO "Backing up XRAY configs..."
  tar czf "$BACKUP_DIR/xray-backup-$(date +%F).tar.gz" /etc/xray 2>/dev/null || log INFO "No XRAY config to backup."

  log INFO "Backing up OpenVPN configs..."
  tar czf "$BACKUP_DIR/openvpn-backup-$(date +%F).tar.gz" /etc/openvpn 2>/dev/null || log INFO "No OpenVPN config to backup."

  log INFO "Backing up SlowDNS data..."
  tar czf "$BACKUP_DIR/slowdns-backup-$(date +%F).tar.gz" /opt/slowdns 2>/dev/null || log INFO "No SlowDNS data to backup."

  log INFO "Backup completed locally."
}

function upload_backup() {
  if ! command -v rclone &>/dev/null; then
    log INFO "rclone is not installed. Installing now..."
    install_package rclone
  fi

  if rclone listremotes | grep -q "^${REMOTE_RCLONE_REMOTE}$"; then
    log INFO "Uploading backups to remote $REMOTE_RCLONE_REMOTE"
    rclone copy "$BACKUP_DIR" "$REMOTE_RCLONE_REMOTE" --progress
    log INFO "Upload complete."
  else
    log INFO "Remote $REMOTE_RCLONE_REMOTE not found. Please configure rclone remote."
  fi
}

function restore_backup() {
  whiptail --title "Restore Backup" --yesno "Restore backup from remote? This will overwrite current configs." 8 60
  if [[ $? -eq 0 ]]; then
    if rclone listremotes | grep -q "^${REMOTE_RCLONE_REMOTE}$"; then
      log INFO "Downloading backups from remote $REMOTE_RCLONE_REMOTE"
      rclone copy "$REMOTE_RCLONE_REMOTE" "$BACKUP_DIR" --progress
      log INFO "Restoring XRAY configs..."
      tar xzf "$BACKUP_DIR"/xray-backup-*.tar.gz -C /
      log INFO "Restoring OpenVPN configs..."
      tar xzf "$BACKUP_DIR"/openvpn-backup-*.tar.gz -C /
      log INFO "Restoring SlowDNS data..."
      tar xzf "$BACKUP_DIR"/slowdns-backup-*.tar.gz -C /
      log INFO "Restore completed."
    else
      log INFO "Remote $REMOTE_RCLONE_REMOTE not found. Please configure rclone remote."
    fi
  else
    log INFO "Restore cancelled by user."
  fi
}

PS3="Choose an option: "
options=("Backup" "Upload Backup" "Restore Backup" "Exit")

select opt in "${options[@]}"; do
  case $opt in
    "Backup")
      backup_data
      ;;
    "Upload Backup")
      upload_backup
      ;;
    "Restore Backup")
      restore_backup
      ;;
    "Exit")
      break
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
done