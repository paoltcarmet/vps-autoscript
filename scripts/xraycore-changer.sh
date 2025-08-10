#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Change XRAY core version..."

read -rp "Enter XRAY Core version (e.g. v1.7.5): " VERSION

if [[ -z "$VERSION" ]]; then
  log INFO "No version entered. Abort."
  exit 1
fi

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
  XRAY_URL="https://github.com/XTLS/Xray-core/releases/download/$VERSION/Xray-linux-64.zip"
elif [[ "$ARCH" == "aarch64" ]]; then
  XRAY_URL="https://github.com/XTLS/Xray-core/releases/download/$VERSION/Xray-linux-arm64.zip"
else
  log INFO "Unsupported architecture: $ARCH"
  exit 1
fi

cd /tmp || exit
curl -L "$XRAY_URL" -o xray.zip
unzip -o xray.zip -d xray
install -m 755 xray/xray /usr/local/bin/xray
rm -rf xray xray.zip

systemctl restart xray

log INFO "XRAY core updated to $VERSION."