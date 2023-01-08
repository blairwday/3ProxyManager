#!/bin/bash
set -e

local timezone="America/Chicago"
echo "${timezone}" | sudo tee /etc/timezone
sudo ln -fs "/usr/share/zoneinfo/${timezone}" /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

echo "Timezone is set to $(cat /etc/timezone)" >&3


