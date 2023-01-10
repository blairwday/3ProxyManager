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
