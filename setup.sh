#!/bin/bash
set -e

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

current_dir=$(getCurrentDir)
output_file="output.log"

read -r timezone
if [ -z "${timezone}" ]; then
    timezone="America/Chicago"
fi
setTimezone "${timezone}"
echo "Timezone is set to $(cat /etc/timezone)" >&3
