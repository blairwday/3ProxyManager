#!/bin/bash
set -e

read -r timezone
if [ -z "${timezone}" ]; then
    timezone="America/Chicago"
fi
setTimezone "${timezone}"
echo "Timezone is set to $(cat /etc/timezone)" >&3

function setTimezone() {
    local timezone=${1}
    echo "${1}" | sudo tee /etc/timezone
    sudo ln -fs "/usr/share/zoneinfo/${timezone}" /etc/localtime
    sudo dpkg-reconfigure -f noninteractive tzdata
}
