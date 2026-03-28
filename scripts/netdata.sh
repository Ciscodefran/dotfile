#!/bin/bash
set -e

PM=$1
PKG_NAME=$2

if ! command -v uuidgen &> /dev/null; then
    echo "Installing $PKG_NAME..."
    $PM install -y "$PKG_NAME"
fi

if ! command -v netdata &> /dev/null; then
    wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && \
    sh /tmp/netdata-kickstart.sh --non-interactive
fi

if [ ! -f /etc/netdata/stream.conf ] || ! grep -q "api key" /etc/netdata/stream.conf; then
    NETDATA_API_KEY=$(uuidgen)

    sudo tee /etc/netdata/netdata.conf > /dev/null <<EOF
[db]
    mode = none
[health]
    enabled = no
[web]
    mode = none
EOF

    sudo tee /etc/netdata/stream.conf > /dev/null <<EOF
[stream]
    enabled = yes
    destination = 192.168.122.1:19999
    api key = $NETDATA_API_KEY
EOF

    sudo systemctl restart netdata

    echo "-------------------------------------------------------"
    echo "API KEY: $NETDATA_API_KEY"
    echo "-------------------------------------------------------"
else
    echo ">>> Netdata config already exists, skipping configuration."
fi
