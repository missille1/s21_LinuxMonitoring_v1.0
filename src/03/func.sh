#!/bin/bash

printinfo() {
    echo "HOSTNAME = $(hostname)"

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
    echo "TIMEZONE = $tz UTC $off"

    echo "USER = $(whoami)"

    echo "OS = $(lsb_release -ds)"

    echo "DATE = $(date +"%d %b %Y %H:%M:%S")"

    echo "UPTIME = $(uptime -p)"

    up_sec=$(awk '{print int($1)}' /proc/uptime)
    echo "UPTIME_SEC = $up_sec"

    ip=$(ip -4 -o addr show scope global | awk '{print $4}' | head -n1 | cut -d/ -f1) # -d/ разделитель полей -f1 взять первое поле
    echo "IP = $ip"

    ip_mask=$(ip -4 -o addr show scope global | awk '{print $4}' | head -n1)
    mask=$(ipcalc "$ip_mask" | awk '/Netmask/ {print $2; exit}') # exit гарантия одного вывода
    echo "MASK = $mask"

    gateway=$(ip route | awk '/default/ {print $3; exit}')
    echo "GATEWAY = $gateway"

    ram_total=$(free -b | awk 'NR==2{printf "%.3f", $2/1024/1024/1024}') # NR==2 вторая строка 
    echo "RAM_TOTAL = $ram_total GB"

    ram_used=$(free -b | awk 'NR==2{printf "%.3f", $3/1024/1024/1024}')
    echo "RAM_USED = $ram_used GB"

    ram_free=$(free -b | awk 'NR==2{printf "%.3f", $4/1024/1024/1024}')
    echo "RAM_FREE = $ram_free GB"

    space_root=$(df  -B1 / | awk 'NR==2{printf "%.2f", $2/1024/1024}')
    echo "SPACE_ROOT = $space_root MB"

    space_root_used=$(df  -B1 / | awk 'NR==2{printf "%.2f", $3/1024/1024}')
    echo "SPACE_ROOT_USED = $space_root_used MB"

    space_root_free=$(df  -B1 / | awk 'NR==2{printf "%.2f", $4/1024/1024}')
    echo "SPACE_ROOT_FREE = $space_root_free MB"
}

question () {
    read -r -p "Save to file? (Y/N): " ans # r не интерпретировать обратную косую \
    case "$ans" in
        [Yy])
            fname="$(date +'%d_%m_%y_%H_%M_%S').status"
            printf '%s\n' "$1" > "$fname" # %s вывести строку и \n перевод строки 
            echo "Saved to $fname"
            ;; #конец шаблона
        *)
            echo "Not saved."
            ;;
    esac
}
