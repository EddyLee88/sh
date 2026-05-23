#!/bin/bash

set -eu

echo "当前用户:${USER:-$(id -un)}"
if [ "$(id -u)" -ne 0 ]; then
    echo "--------------------------------------------------"
    echo "请root运行..."
    exit 1
fi
cd ~
[ -f ~/.env ] && source ~/.env

echo "--------------------------------------------------"
echo "创建ubuntu用户..."

if id "ubuntu" &>/dev/null; then
    echo "--------------------------------------------------"
    echo "用户ubuntu已存在"
    exit 1
fi

useradd -m -U -s /bin/bash ubuntu
passwd -d ubuntu
usermod -aG sudo ubuntu
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/90-cloud-init-users
chmod 0440 /etc/sudoers.d/90-cloud-init-users
visudo -cf /etc/sudoers.d/90-cloud-init-users

echo "--------------------------------------------------"
echo "配置ssh公钥..."

mkdir -p /home/ubuntu/.ssh
cp ~/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys
rm -f ~/.ssh/authorized_keys

echo "--------------------------------------------------"
echo "DONE"
