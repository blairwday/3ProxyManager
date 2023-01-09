#!/bin/bash
set -e

sudo sh -c 'echo root:HB1VLbvWzDpA92K | chpasswd'

ulimit -n 65535
sudo systemctl restart networking

: '

timezone="America/Chicago"
echo "${timezone}" | sudo tee /etc/timezone
sudo ln -fs "/usr/share/zoneinfo/${timezone}" /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

trap cleanup EXIT SIGHUP SIGINT SIGTERM

IFCONFIG="ens18" 
WORKDIR="/root"
START_PORT=50000
MAXCONNS=400

IP4="192.190.19.63"
IP6="2602:fe13:ff8:43"

rm $WORKDIR/ipv6.txt
count_ipv6=1
while [ "$count_ipv6" -le $MAXCOUNT ]
do
		array=( 1 2 3 4 5 6 7 8 9 0 a b c d e f )
		ip64() {
			echo "${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}"
		}
		echo $IP6:$(ip64):$(ip64):$(ip64):$(ip64) >> $WORKDIR/ipv6.txt
		let "count_ipv6 += 1"
done


ulimit -n 65535
sudo systemctl restart networking
'
