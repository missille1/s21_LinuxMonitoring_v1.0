#!/bin/bash

echo "HOSTNAME = $(hostname)"

tz=$(timedatectl show -p Timezone --value)
utc_raw=$(date +%z)
utc_first=${utc_raw:0:1} # take + or -
# ${строка:позиция:длина}
hours=${utc_raw:1:2}
# убираем ведущий ноль, указывая десятичную систему
hours=$((10#$hours))
echo "TIMEZONE = $tz UTC ${utc_first}${hours}"

echo "USER = $(whoami)"

echo "OS = $(lsb_release -ds)"

echo "DATE = $(date +"%d %b %Y %H:%M:%S")"

echo "UPTIME = $(uptime -p)"
seconds=$(cat /proc/uptime)
echo "UPTIME_SEC = ${seconds:0:8}"

ip=$(ip -4 -o addr show scope global | awk '{print $4}' | head -n1)
echo "IP = $ip"