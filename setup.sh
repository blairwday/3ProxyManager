#!/bin/bash
set -e
current_dir=$(getCurrentDir)
output_file="output.log"

read -r timezone
if [ -z "${timezone}" ]; then
    timezone="America/Chicago"
fi
setTimezone "${timezone}"
echo "Timezone is set to $(cat /etc/timezone)" >&3
