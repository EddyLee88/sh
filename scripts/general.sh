#!/bin/bash

set -eu

DNS_SERVER="8.8.8.8"
FALLBACK_DNS_SERVER="1.1.1.1"
SWAP_FILE="/swapfile"
ZRAM_CONFIG="/etc/systemd/zram-generator.conf"

MEMORY_GB=$(awk '/^MemTotal:/ {print int(($2 + 1024 * 1024 - 1) / (1024 * 1024))}' /proc/meminfo)
ZRAM_SIZE_MB=$(( MEMORY_GB * 1024 / 2 ))

echo "--------------------------------------------------"
echo "更新仓库和软件包..."

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

echo "--------------------------------------------------"
echo "设置swap分区: ${MEMORY_GB}G..."

sudo swapoff "$SWAP_FILE" 2>/dev/null || true
sudo sed -i.bak "\|^${SWAP_FILE}[[:space:]]|d" /etc/fstab 2>/dev/null || true
sudo rm -f "$SWAP_FILE"

sudo fallocate -l "${MEMORY_GB}G" "$SWAP_FILE"
sudo chmod 600 "$SWAP_FILE"
sudo mkswap "$SWAP_FILE"
sudo swapon "$SWAP_FILE"
echo "${SWAP_FILE} none swap sw 0 0" | sudo tee -a /etc/fstab >/dev/null

echo "--------------------------------------------------"
echo "设置zram: ${ZRAM_SIZE_MB}M..."

sudo apt install -y linux-modules-extra-$(uname -r) systemd-zram-generator

sudo tee "$ZRAM_CONFIG" >/dev/null <<EOF
[zram0]
zram-size = ${ZRAM_SIZE_MB}M
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

sudo systemctl daemon-reload
# sudo systemctl restart /dev/zram0 || sudo systemctl start /dev/zram0
sudo systemctl restart systemd-zram-setup@zram0.service || sudo systemctl start systemd-zram-setup@zram0.service

echo "--------------------------------------------------"
echo "设置DNS: ${DNS_SERVER}, fallback: ${FALLBACK_DNS_SERVER}..."

sudo mkdir -p /etc/systemd/resolved.conf.d

sudo tee /etc/systemd/resolved.conf.d/dns.conf >/dev/null <<EOF
[Resolve]
DNS=${DNS_SERVER}
FallbackDNS=${FALLBACK_DNS_SERVER}
EOF

sudo systemctl enable --now systemd-resolved.service
sudo systemctl restart systemd-resolved.service

echo "--------------------------------------------------"
echo "当前swap/zram状态:"
swapon --show

echo "--------------------------------------------------"
echo "DONE"
