#!/bin/bash

color_letters() {
    case "$1" in 
        1) echo 37 ;; 2) echo 31 ;; 3) echo 32 ;; # ANSI color
        4) echo 34 ;; 5) echo 35 ;; 6) echo 30 ;;
    esac
}

color_background() {
    case "$1" in
        1) echo 47 ;; 2) echo 41 ;; 3) echo 42 ;;
        4) echo 44 ;; 5) echo 45 ;; 6) echo 40 ;;
    esac 
}

paint() {
    local cb cl
    cb=$(color_background "$1"); cl=$(color_letters "$2")
    # \e[\e - начало и конец,s переменные (фон, цвет бук., сам текст),m конец SRG,[0m сброс цвета в дефолт
    printf '\e[%s;%sm%s\e[0m' "$cb" "$cl" "$3"
}

print_text() {
    local label="$1" value="$2" color1="$3" color2="$4" color3="$5" color4="$6"

    printf '%s = %s\n' \
        "$(paint "$color1" "$color2" "$label")" \
        "$(paint "$color3" "$color4" "$value")"
}