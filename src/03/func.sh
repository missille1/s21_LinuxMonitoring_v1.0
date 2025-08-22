#!/bin/bash

info() {
    HOSTNAME="$(hostname)"

    tz=$(timedatectl show -p Timezone --value)
    utc_raw=$(date +%z)
    utc_first=${utc_raw:0:1} # take + or -
    # ${строка:позиция:длина}
    hours=${utc_raw:1:2}
    # убираем ведущий ноль, указывая десятичную систему
    hours=$((10#$hours))
    mins=${utc_raw:3:2}
    if [ "$mins" != "00" ]; then
        off="${utc_first}${hours}:${mins}"
    else
        off="${utc_first}${hours}"
    fi
    TIMEZONE="$tz UTC $off"

    USER="$(whoami)"

    OS="$(lsb_release -ds)"

    DATE="$(date +"%d %b %Y %H:%M:%S")"

    UPTIME="$(uptime -p)"

    up_sec=$(awk '{print int($1)}' /proc/uptime)
    UPTIME_SEC="$up_sec"

    ip=$(ip -4 -o addr show scope global | awk '{print $4}' | head -n1 | cut -d/ -f1) # -d/ разделитель полей -f1 взять первое поле
    IP="$ip"

    ip_mask=$(ip -4 -o addr show scope global | awk '{print $4}' | head -n1)
    mask=$(ipcalc "$ip_mask" | awk '/Netmask/ {print $2; exit}') # exit гарантия одного вывода
    MASK="$mask"

    gateway=$(ip route | awk '/default/ {print $3; exit}')
    GATEWAY="$gateway"

    ram_total=$(free -b | awk 'NR==2{printf "%.3f", $2/1024/1024/1024}') # NR==2 вторая строка 
    RAM_TOTAL="$ram_total GB"

    ram_used=$(free -b | awk 'NR==2{printf "%.3f", $3/1024/1024/1024}')
    RAM_USED="$ram_used GB"

    ram_free=$(free -b | awk 'NR==2{printf "%.3f", $4/1024/1024/1024}')
    RAM_FREE="$ram_free GB"

    space_root=$(df  -B1 / | awk 'NR==2{printf "%.2f", $2/1024/1024}')
    SPACE_ROOT="$space_root MB"

    space_root_used=$(df  -B1 / | awk 'NR==2{printf "%.2f", $3/1024/1024}')
    SPACE_ROOT_USED="$space_root_used MB"

    space_root_free=$(df  -B1 / | awk 'NR==2{printf "%.2f", $4/1024/1024}')
    SPACE_ROOT_FREE="$space_root_free MB"
}

print() {
    print_text "HOSTNAME"        "$HOSTNAME"         "$1" "$2" "$3" "$4"
    print_text "TIMEZONE"        "$TIMEZONE"         "$1" "$2" "$3" "$4"
    print_text "USER"            "$USER"             "$1" "$2" "$3" "$4"
    print_text "OS"              "$OS"               "$1" "$2" "$3" "$4"
    print_text "DATE"            "$DATE"             "$1" "$2" "$3" "$4"
    print_text "UPTIME"          "$UPTIME"           "$1" "$2" "$3" "$4"
    print_text "UPTIME_SEC"      "$UPTIME_SEC"       "$1" "$2" "$3" "$4"
    print_text "IP"              "$IP"               "$1" "$2" "$3" "$4"
    print_text "MASK"            "$MASK"             "$1" "$2" "$3" "$4"
    print_text "GATEWAY"         "$GATEWAY"          "$1" "$2" "$3" "$4"
    print_text "RAM_TOTAL"       "$RAM_TOTAL"        "$1" "$2" "$3" "$4"
    print_text "RAM_USED"        "$RAM_USED"         "$1" "$2" "$3" "$4"
    print_text "RAM_FREE"        "$RAM_FREE"         "$1" "$2" "$3" "$4"
    print_text "SPACE_ROOT"      "$SPACE_ROOT"       "$1" "$2" "$3" "$4"
    print_text "SPACE_ROOT_USED" "$SPACE_ROOT_USED"  "$1" "$2" "$3" "$4"
    print_text "SPACE_ROOT_FREE" "$SPACE_ROOT_FREE"  "$1" "$2" "$3" "$4"
}