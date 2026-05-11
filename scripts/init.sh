#!/bin/bash

set -eu

echo "当前用户:${USER:-$(id -un)}"
cd ~

echo "--------------------------------------------------"
echo "获取脚本变量..."

MAX_SWAP_GB=8
MEMORY_GB=$(awk -v max="$MAX_SWAP_GB" '/^MemTotal:/ {gb = int(($2 + 1024 * 1024 - 1) / (1024 * 1024)); if (gb > max) gb = max; print gb}' /proc/meminfo)
SWAP_SIZE_BYTES=$(( MEMORY_GB * 1024 * 1024 * 1024 ))
ZRAM_SIZE_MB=$(( MEMORY_GB * 1024 / 2 ))
SWAP_FILE="/swapfile"
FSTAB_SWAP_LINE="${SWAP_FILE} none swap defaults,pri=10 0 0"
ZRAM_MODULE_PACKAGE="linux-modules-extra-$(uname -r)"
ZRAM_CONFIG="/etc/systemd/zram-generator.conf"
SYSCTL_CONFIG="/etc/sysctl.d/99-swap.conf"
DNS_SERVER="8.8.8.8"
FALLBACK_DNS_SERVER="1.1.1.1"

echo "--------------------------------------------------"
echo "更新apt仓库和软件包..."

if ! dpkg -s sudo >/dev/null 2>&1; then
  apt install sudo -y
fi

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo apt install zsh vim wget curl git podman software-properties-common -y

if ! dpkg -s fastfetch >/dev/null 2>&1; then
  sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
  sudo apt update
  sudo apt install fastfetch -y
fi

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

sudo modprobe zram 2>/dev/null || {
  sudo apt install -y "$ZRAM_MODULE_PACKAGE"
  sudo modprobe zram
}

sudo apt install -y systemd-zram-generator

sudo tee "$ZRAM_CONFIG" >/dev/null <<EOF
[zram0]
zram-size = min(ram / 2, ${ZRAM_SIZE_MB}, ${MAX_SWAP_GB} * 1024 / 2)
swap-priority = 20
EOF

sudo systemctl daemon-reload
sudo systemctl restart systemd-zram-setup@zram0.service

echo "--------------------------------------------------"
echo "设置内存交换策略..."

sudo tee "$SYSCTL_CONFIG" >/dev/null <<EOF
vm.swappiness=20
vm.page-cluster=0
EOF

sudo sysctl -p "$SYSCTL_CONFIG"

echo "--------------------------------------------------"
echo "当前swap/zram状态:"

swapon --show
free -h

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
echo "当前DNS:"

resolvectl dns

echo "--------------------------------------------------"
echo "关闭防火墙..."

sudo ufw disable 2>/dev/null || true

reset_iptables() {
  command -v "$1" >/dev/null 2>&1 || return 0

  for option in -F -X -Z; do
    sudo "$1" "$option" 2>/dev/null || true
  done

  for chain in INPUT FORWARD OUTPUT; do
    sudo "$1" -P "$chain" ACCEPT 2>/dev/null || true
  done
}

reset_iptables iptables
reset_iptables ip6tables

echo "--------------------------------------------------"
echo "DONE"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://install.ohmyz.sh/)"
fi
