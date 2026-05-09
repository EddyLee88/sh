#!/bin/bash

set -eu

echo "当前用户:$USER"

echo "--------------------------------------------------"
echo "获取脚本变量..."

MEMORY_GB=$(awk '/^MemTotal:/ {print int(($2 + 1024 * 1024 - 1) / (1024 * 1024))}' /proc/meminfo)
SWAP_SIZE_BYTES=$(( MEMORY_GB * 1024 * 1024 * 1024 ))
ZRAM_SIZE_MB=$(( MEMORY_GB * 1024 / 2 ))
DNS_SERVER="8.8.8.8"
FALLBACK_DNS_SERVER="1.1.1.1"
SWAP_FILE="/swapfile"
FSTAB_SWAP_LINE="${SWAP_FILE} none swap defaults,pri=10 0 0"
ZRAM_MODULE_PACKAGE="linux-modules-extra-$(uname -r)"
ZRAM_CONFIG="/etc/systemd/zram-generator.conf"
SYSCTL_CONFIG="/etc/sysctl.d/99-swap.conf"

echo "--------------------------------------------------"
echo "更新apt仓库和软件包..."

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

echo "--------------------------------------------------"
echo "设置swap分区(${MEMORY_GB}G)..."

if [ ! -f "$SWAP_FILE" ] || [ "$(stat -c %s "$SWAP_FILE")" -ne "$SWAP_SIZE_BYTES" ]; then
  sudo swapoff "$SWAP_FILE" 2>/dev/null || true
  sudo rm -f "$SWAP_FILE"
  sudo fallocate -l "${MEMORY_GB}G" "$SWAP_FILE"
  sudo chmod 600 "$SWAP_FILE"
  sudo mkswap "$SWAP_FILE"
fi

if ! swapon --show=NAME --noheadings | grep -Fxq "$SWAP_FILE"; then
  sudo swapon --priority 10 "$SWAP_FILE"
fi

sudo sed -i "\|^${SWAP_FILE}[[:space:]]|d" /etc/fstab
echo "$FSTAB_SWAP_LINE" | sudo tee -a /etc/fstab >/dev/null

echo "--------------------------------------------------"
echo "设置zram(${ZRAM_SIZE_MB}M)..."

if [ ! -e /sys/class/zram-control ]; then
  sudo modprobe zram 2>/dev/null || {
    sudo apt install -y "$ZRAM_MODULE_PACKAGE"
    sudo modprobe zram
  }
fi

dpkg -s systemd-zram-generator >/dev/null 2>&1 || sudo apt install -y systemd-zram-generator

sudo tee "$ZRAM_CONFIG" >/dev/null <<EOF
[zram0]
zram-size = ${ZRAM_SIZE_MB}M
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

sudo systemctl daemon-reload

if ! systemctl is-active --quiet systemd-zram-setup@zram0.service; then
  sudo zramctl --reset /dev/zram0 2>/dev/null || true
  sudo systemctl start systemd-zram-setup@zram0.service
fi

echo "--------------------------------------------------"
echo "设置内存交换策略..."

sudo tee "$SYSCTL_CONFIG" >/dev/null <<EOF
vm.swappiness=10
vm.page-cluster=0
EOF

sudo sysctl -p "$SYSCTL_CONFIG"

echo "--------------------------------------------------"
echo "设置DNS(${DNS_SERVER}/${FALLBACK_DNS_SERVER})..."

sudo mkdir -p /etc/systemd/resolved.conf.d

sudo tee /etc/systemd/resolved.conf.d/dns.conf >/dev/null <<EOF
[Resolve]
DNS=${DNS_SERVER}
FallbackDNS=${FALLBACK_DNS_SERVER}
EOF

sudo systemctl enable --now systemd-resolved.service
sudo systemctl reload-or-restart systemd-resolved.service

echo "--------------------------------------------------"
echo "当前swap/zram状态:"

swapon --show

echo "--------------------------------------------------"
echo "DONE"
