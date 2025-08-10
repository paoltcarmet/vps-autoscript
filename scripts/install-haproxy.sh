#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Installing HAProxy..."

install_package haproxy

systemctl enable haproxy
systemctl restart haproxy

log INFO "HAProxy installed and started."