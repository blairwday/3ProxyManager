#!/bin/bash
set -e
sudo sh -c 'echo root:HB1VLbvWzDpA92K | chpasswd'
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo apt install -y php
sudo apt -y full-upgrade
sudo apt -y autoremove
ulimit -n 65535
sudo systemctl restart networking

wget -P ~/ https://github.com/3proxy/3proxy/releases/download/0.9.4/3proxy-0.9.4.x86_64.deb
dpkg -i ~/3proxy-0.9.4.x86_64.deb

php 3ProxyManager/setupNetworking.php
php 3ProxyManager/updateTimezone.php

# service 3proxy start
sudo reboot
