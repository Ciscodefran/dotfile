#!/bin/bash
echo ">>> Setting up Netdata (Headless Collector) with Dynamic UUID..."

if ! command -v uuidgen &> /dev/null; then
    sudo apt update && sudo apt install -y uuid-runtime
fi

NETDATA_API_KEY=$(uuidgen)

if ! command -v netdata &> /dev/null; then
    wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && \
    sh /tmp/netdata-kickstart.sh --non-interactive
fi

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
echo "Netdata 설치 및 스트리밍 설정이 완료되었습니다."
echo "-------------------------------------------------------"
