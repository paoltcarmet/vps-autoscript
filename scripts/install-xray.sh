#!/usr/bin/env bash
source ../utils/functions.sh

log INFO "Installing XRAY core..."

install_package curl unzip socat

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
  XRAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"
elif [[ "$ARCH" == "aarch64" ]]; then
  XRAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-arm64.zip"
else
  log INFO "Unsupported architecture: $ARCH"
  exit 1
fi

mkdir -p /usr/local/bin
cd /tmp || exit
curl -L "$XRAY_URL" -o xray.zip
unzip -o xray.zip -d xray
install -m 755 xray/xray /usr/local/bin/xray
rm -rf xray xray.zip

mkdir -p /etc/xray

# Placeholder XRAY config example, user should edit after install
cat >/etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "00000000-0000-0000-0000-000000000000",
            "flow": "xtls-rprx-direct"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "serverName": "yourdomain.com",
          "alpn": ["h2", "http/1.1"],
          "certificates": [
            {
              "certificateFile": "/etc/xray/cert.pem",
              "keyFile": "/etc/xray/key.pem"
            }
          ]
        },
        "wsSettings": { "path": "/vless" }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom", "settings": {} }]
}
EOF

cat >/etc/systemd/system/xray.service <<EOF
[Unit]
Description=Xray Service
After=network.target nss-lookup.target

[Service]
User=root
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

restart_service xray
log INFO "XRAY installation and service setup complete."