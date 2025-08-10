#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Installing Nginx..."

install_package nginx

systemctl enable nginx
systemctl restart nginx

log INFO "Nginx installed and running."