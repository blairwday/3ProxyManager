#!/bin/bash
set -e

echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
sudo systemctl restart sshd


sudo sh -c 'echo root:HB1VLbvWzDpA92K | chpasswd'

ulimit -n 65535
sudo systemctl restart networking

: '
sudo apt install -y php

sudo apt -y full-upgrade
sudo apt autoremove




sudo passwd root
sudo nano /etc/ssh/sshd_config
PermitRootLogin yes
sudo systemctl restart sshd
'
