#!/bin/bash 

check () {
    local DIR="$1"

    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <dir/>" # только один параметр оканчивается на /
        exit 1
    fi

    # проверка на /
    if [[ "$DIR" != */ ]]; then
        echo "Ошибка: путь должен оканчиваться на '/'. Пример: $0 /var/log"
        exit 1
    fi

    if [ ! -d "$DIR" ]; then
        echo "Ошибка '$DIR' - не существует или не директория" 
        exit 1
    fi
}
