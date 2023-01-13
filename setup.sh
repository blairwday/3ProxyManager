#!/bin/bash
set -e
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
sudo systemctl restart sshd
ssh-keygen -i -f ~/3ProxyManager/publicKey.pub > ~/3ProxyManager/rsa.pub
mkdir -p ~/.ssh
cat ~/3ProxyManager/rsa.pub >> ~/.ssh/authorized_keys
sudo systemctl restart sshd
sudo apt install -y php net-tools
sudo apt-get -o Dpkg::Options::="--force-confold" --force-yes -fuy dist-upgrade
sudo apt-get -y autoremove
ulimit -n 65535
sudo systemctl restart networking
sudo timedatectl set-timezone America/Chicago
wget -P ~/ https://github.com/3proxy/3proxy/releases/download/0.9.4/3proxy-0.9.4.x86_64.deb
dpkg -i ~/3proxy-0.9.4.x86_64.deb
php 3ProxyManager/setupNetworking.php

# service 3proxy start
sudo reboot
