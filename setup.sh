#!/bin/bash
set -e
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
systemctl restart sshd
ssh-keygen -i -f ~/3ProxyManager/publicKey.pub > ~/3ProxyManager/rsa.pub
mkdir -p ~/.ssh
cat ~/3ProxyManager/rsa.pub >> ~/.ssh/authorized_keys
systemctl restart sshd
apt-get install -y php net-tools
apt-get -o Dpkg::Options::="--force-confold" --force-yes -fuy dist-upgrade
apt-get -y autoremove
ulimit -n 65535
systemctl restart networking
timedatectl set-timezone America/Chicago
wget -P ~/ https://github.com/3proxy/3proxy/releases/download/0.9.4/3proxy-0.9.4.x86_64.deb
dpkg -i ~/3proxy-0.9.4.x86_64.deb
php 3ProxyManager/setupNetworking.php

# service 3proxy start
sudo reboot
