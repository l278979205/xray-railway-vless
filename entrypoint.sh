#!/bin/sh
set -e

PORT="${PORT:-8080}"
UUID="${XRAY_UUID:-80778efc-4191-49e5-ace0-4309676ee875}"
WS_PATH="${WS_PATH:-618bdff24bcda6864587f577bae27253}"
WS_PATH="/${WS_PATH#/}"

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": $PORT,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$UUID"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "$WS_PATH"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF

XRAY_BIN="$(command -v xray || echo /usr/bin/xray)"
exec "$XRAY_BIN" -config /etc/xray/config.json
